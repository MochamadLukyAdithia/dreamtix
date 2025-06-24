import 'package:dreamtix/features/transaksi/model/TransaksiModel.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dreamtix/core/helper/date.dart' as date;

class TransactionDetailView extends StatelessWidget {
  final TransaksiModel transaction;

  const TransactionDetailView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E21),
      appBar: AppBar(
        title: const Text("Detail Transaksi",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B0E21),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                transaction.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              transaction.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              transaction.status,
              style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
            ),
            const Divider(color: Colors.white38, height: 30),
            buildRow("Tanggal Transaksi", date.formatDate(transaction.date)),
            buildRow("ID Transaksi", transaction.id),
            buildRow("Metode Pembayaran", transaction.metode),
            buildRow("Jumlah Tiket",
                transaction.detailPemesanan[0].quantity.toString()),
            buildRow("Total Pembayaran",
                "Rp ${transaction.detailPemesanan[0].total}"),
            buildRow("Nama Event", "${transaction.nama_event}"),
            buildRow("Waktu", "${transaction.waktu_event}"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => {Get.toNamed("qr", arguments: transaction)},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  "Lihat Tiket",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
