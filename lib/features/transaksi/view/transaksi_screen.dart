import 'package:dreamtix/features/transaksi/controller/TransaksiController.dart';
import 'package:dreamtix/features/transaksi/view/detail_transaksi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Cari Nama Event",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                filled: true,
                fillColor: const Color(0xFF1C1F2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = controller.filteredTransactions[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.network(tx.imageUrl,
                                      width: 80, height: 50, fit: BoxFit.cover),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(tx.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        Text(tx.status,
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14),
                                  const SizedBox(width: 6),
                                  Text("Tanggal Transaksi",
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Text(tx.date,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() =>
                                        TransactionDetailView(transaction: tx));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text(
                                    "Lihat Detail",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
