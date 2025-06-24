import 'dart:convert';
import 'package:dreamtix/features/transaksi/model/QrModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dreamtix/core/const/apiUrl.dart' as apiUrl;


class QrController extends GetxController {
  var isLoading = false.obs;
  var qrList = <QrModel>[].obs;

  Future<void> fetchQrByTiketId(int idTiket, int jumlah) async {
    isLoading.value = true;

    final box = GetStorage();
    final token = box.read("token");

    if (token == null) {
      print('Token tidak ditemukan');
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${apiUrl.apiUrl}/tikets/$idTiket/qr/$jumlah'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> dataList = jsonData['data'];

        qrList.value = dataList.map((item) => QrModel.fromJson(item)).toList();
      } else {
        print('Gagal mengambil data QR: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetchQrByTiketId: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
