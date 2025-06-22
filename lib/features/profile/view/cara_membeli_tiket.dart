import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaraMembeliTiketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E21),
      appBar: AppBar(
        title: const Text("Cara Membeli Tiket",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B0E21),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Panduan Lengkap",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ikuti langkah mudah untuk membeli tiket bioskop",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Step by Step Guide
              _buildStepCard(
                stepNumber: "1",
                title: "Pilih Konser",
                description:
                    "Jelajahi koleksi konser terbaru dan pilih konser yang ingin Anda tonton. Anda dapat melihat trailer, rating, dan ulasan untuk membantu memilih.",
                icon: Icons.movie,
                tips: [
                  "Lihat trailer untuk preview konser",
                  "Baca ulasan dari penonton lain",
                  "Periksa rating dan genre konser"
                ],
              ),

              _buildStepCard(
                stepNumber: "2",
                title: "Pilih Bioskop & Jadwal",
                description:
                    "Pilih bioskop terdekat dan jadwal tayang yang sesuai dengan waktu Anda. Pastikan untuk memeriksa lokasi dan waktu dengan teliti.",
                icon: Icons.location_on,
                tips: [
                  "Pilih bioskop terdekat dari lokasi Anda",
                  "Periksa jadwal tayang yang tersedia",
                  "Perhatikan durasi konser dan waktu berakhir"
                ],
              ),

              _buildStepCard(
                stepNumber: "3",
                title: "Pilih tipe tiket",
                description:
                    "Pilih tipe tiket favorit Anda dari denah bioskop yang tersedia. tipe tiket yang sudah dipesan akan ditandai dengan warna berbeda.",
                icon: Icons.event_seat,
                tips: [
                  "tipe tiket di tengah memberikan pengalaman terbaik",
                  "Hindari tipe tiket paling depan jika tidak suka dekat layar",
                  "Periksa ketersediaan tipe tiket untuk penyandang disabilitas"
                ],
              ),

              _buildStepCard(
                stepNumber: "4",
                title: "Pilih Metode Pembayaran",
                description:
                    "Pilih metode pembayaran yang Anda inginkan dari berbagai opsi yang tersedia seperti kartu kredit, e-wallet, atau transfer bank.",
                icon: Icons.payment,
                tips: [
                  "Periksa promo pembayaran dengan kartu tertentu",
                  "Pastikan saldo atau limit kartu mencukupi",
                  "Simpan bukti pembayaran untuk referensi"
                ],
              ),

              _buildStepCard(
                stepNumber: "5",
                title: "Konfirmasi & Bayar",
                description:
                    "Periksa kembali detail pesanan Anda, lalu lakukan pembayaran. Anda akan menerima tiket digital setelah pembayaran berhasil.",
                icon: Icons.check_circle,
                tips: [
                  "Periksa detail pesanan sebelum bayar",
                  "Pastikan nomor telepon dan email benar",
                  "Simpan tiket digital di perangkat Anda"
                ],
              ),

              const SizedBox(height: 30),

              // Payment Methods
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D3A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Metode Pembayaran",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentMethod(Icons.credit_card, "Qris",
                        "Untuk saat ini hanya bisa via qris"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Important Notes
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Hal Penting",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildImportantNote(
                        "Tiket yang sudah dibeli tidak dapat dibatalkan atau ditukar"),
                    _buildImportantNote(
                        "Datang 15-30 menit sebelum jam tayang dimulai"),
                    _buildImportantNote(
                        "Tunjukkan tiket digital atau cetak tiket di bioskop"),
                    _buildImportantNote(
                        "Bawa identitas diri untuk konser dengan rating tertentu"),
                    _buildImportantNote(
                        "Makanan dan minuman dari luar tidak diperbolehkan"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // FAQ Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D3A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pertanyaan Umum",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem("Bagaimana jika pembayaran gagal?",
                        "Coba lagi dengan metode pembayaran lain atau hubungi customer service"),
                    _buildFAQItem("Bisakah membeli tiket untuk orang lain?",
                        "Ya, Anda bisa membeli tiket untuk siapa saja dengan mengisi data yang sesuai"),
                    _buildFAQItem("Bagaimana cara refund tiket?",
                        "Tiket tidak dapat di-refund, kecuali ada pembatalan dari pihak bioskop"),
                    _buildFAQItem("Apakah bisa pilih tipe tiket khusus?",
                        "Ya, tersedia tipe tiket untuk lansia, penyandang disabilitas, dan couple seat"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required List<String> tips,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(icon, color: Colors.red, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Tips:",
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(color: Colors.red)),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNote(String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Colors.red)),
          Expanded(
            child: Text(
              note,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q: $question",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "A: $answer",
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
