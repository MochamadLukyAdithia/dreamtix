import 'package:dreamtix/core/theme/network.dart';
import 'package:dreamtix/features/transaksi/model/TransaksiModel.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  var searchQuery = ''.obs;

  var transactions = <Transaction>[
    Transaction("PRESTON LIVE FEST 2025", "15 Juli 2025, 20:18 WIB",
        "${NetworkImageAssets.bannerImages[0]}", "Payment Active", "1", "haha"),
    Transaction(
        "PRESTON LIVE FEST 2025",
        "15 Juli 2025, 20:18 WIB",
        "${NetworkImageAssets.bannerImages[0]}",
        "Payment Active",
        "2 ",
        "haha"),
  ].obs;

  List<Transaction> get filteredTransactions => transactions
      .where((e) =>
          e.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
      .toList();
}
