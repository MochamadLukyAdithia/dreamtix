import 'package:dreamtix/features/transaksi/controller/QrController.dart';
import 'package:dreamtix/features/transaksi/model/TransaksiModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrScreen extends StatelessWidget {
  final TransaksiModel tiket;
  const QrScreen({super.key, required this.tiket});

  @override
  Widget build(BuildContext context) {
    final qrController = Get.put(QrController());

    // Fetch QR saat screen dibuka
    qrController.fetchQrByTiketId(
        int.parse(tiket.id_tiket), int.parse(tiket.jumlah));

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Tiket'),
        backgroundColor: Color(0xFF0B0E21),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
      if (qrController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (qrController.qrList.isEmpty) {
          return const Center(child: Text('QR tidak ditemukan'));
        }

        return ListView.builder(
          itemCount: qrController.qrList.length,
          itemBuilder: (context, index) {
            final qr = qrController.qrList[index];
            return Card(
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Image.network(
                      qr.qrUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Chip(
                      label: Text(
                        qr.isUsed ? "SUDAH DIGUNAKAN" : "BELUM DIGUNAKAN",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: qr.isUsed ? Colors.red : Colors.green,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
