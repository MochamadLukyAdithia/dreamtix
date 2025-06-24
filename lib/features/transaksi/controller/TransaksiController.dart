import 'dart:convert';
import 'package:dreamtix/features/auth/model/UserModel.dart';
import 'package:dreamtix/features/transaksi/model/TransaksiModel.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:dreamtix/core/const/apiUrl.dart' as apiUrl;

class TransactionController extends GetxController {
  var searchQuery = ''.obs;

  /// List transaksi hasil fetch dari API
  var transactions = <TransaksiModel>[].obs;

  /// Filter berdasarkan judul
  List<TransaksiModel> get filteredTransactions => transactions
      .where((e) =>
          e.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
      .toList();

  final user = Rxn<Usermodel>();
  final isLoading = false.obs;

  /// Format tanggal ISO ke format lokal
  String _formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('dd MMMM yyyy, HH:mm WIB', 'id_ID').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  /// Fetch data transaksi dari API backend
  Future<void> fetchTransactions() async {
    isLoading.value = true;

    final box = GetStorage(); // ambil token dari penyimpanan lokal
    final token = box.read("token");

    if (token == null) {
      print('Token tidak ditemukan');
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${apiUrl.apiUrl}/transaksi'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> dataList = jsonData['data'];

        final fetchedTransactions = dataList
            .map<TransaksiModel>(
                (item) => TransaksiModel.fromJson(item, _formatDate))
            .toList();

        transactions.value = fetchedTransactions;
      } else {
        print('Gagal mengambil data transaksi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetchTransactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }
}
