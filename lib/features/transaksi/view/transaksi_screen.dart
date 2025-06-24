import 'package:dreamtix/core/theme/network.dart';
import 'package:dreamtix/features/transaksi/controller/TransaksiController.dart';
import 'package:dreamtix/features/transaksi/view/detail_transaksi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamtix/core/helper/date.dart' as date;

class TransactionView extends StatelessWidget {
  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E21),
      appBar: AppBar(
        title: const Text("Riwayat Transaksi",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B0E21),
        elevation: 0,
        centerTitle: true,
        leading: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (controller.filteredTransactions.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada transaksi",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.filteredTransactions.length,
            itemBuilder: (context, index) {
              final tx = controller.filteredTransactions[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              NetworkImageAssets.bannerImage[0],
                              width: 80,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 80,
                                height: 50,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  "Metode: ${tx.metode}",
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                ),
                                Text(
                                  "Status: ${tx.status}",
                                  style: TextStyle(
                                      color: tx.status == "LUNAS"
                                          ? Colors.green
                                          : Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            "Tanggal Transaksi",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        date.formatDate(tx.date),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(
                                () => TransactionDetailView(transaction: tx));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text(
                            "Lihat Detail",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
