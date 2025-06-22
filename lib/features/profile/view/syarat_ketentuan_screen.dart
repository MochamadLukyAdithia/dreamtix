import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyaratKetentuanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E21),
      appBar: AppBar(
        title: const Text("Syarat Dan Ketentuan",
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
                "Syarat dan Ketentuan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Terakhir diperbarui: 15 Juni 2025",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              _buildSection(
                title: "1. Penerimaan Syarat",
                content:
                    "Dengan mengakses dan menggunakan aplikasi DreamTix, Anda menyetujui untuk terikat oleh syarat dan ketentuan ini. Jika Anda tidak setuju dengan syarat dan ketentuan yang ditetapkan, mohon untuk tidak menggunakan layanan kami.",
              ),

              _buildSection(
                title: "2. Deskripsi Layanan",
                content:
                    "DreamTix adalah platform digital yang menyediakan layanan pemesanan tiket bioskop online. Kami menyediakan informasi tentang film, jadwal tayang, harga tiket, dan memfasilitasi transaksi pembelian tiket bioskop.",
              ),

              _buildSection(
                title: "3. Pendaftaran Akun",
                content:
                    "• Anda harus berusia minimal 17 tahun untuk membuat akun\n• Informasi yang Anda berikan harus akurat dan lengkap\n• Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi\n• Anda bertanggung jawab atas semua aktivitas yang terjadi di akun Anda\n• Kami berhak menangguhkan atau menghapus akun yang melanggar ketentuan",
              ),

              _buildSection(
                title: "4. Pemesanan dan Pembayaran",
                content:
                    "• Semua pemesanan tiket bersifat final setelah pembayaran dikonfirmasi\n• Harga tiket dapat berubah sewaktu-waktu tanpa pemberitahuan sebelumnya\n• Pembayaran harus dilakukan sesuai dengan metode yang tersedia\n• Kami tidak bertanggung jawab atas kegagalan pembayaran dari pihak ketiga\n• Bukti pembelian harus ditunjukkan saat memasuki bioskop",
              ),

              _buildSection(
                title: "5. Kebijakan Pembatalan dan Pengembalian",
                content:
                    "• Tiket yang telah dibeli tidak dapat dibatalkan atau dikembalikan\n• Dalam kasus tertentu seperti pembatalan acara oleh bioskop, pengembalian dana akan diproses sesuai kebijakan masing-masing bioskop\n• Proses pengembalian dana dapat memakan waktu 3-14 hari kerja\n• Biaya administrasi mungkin akan dikenakan untuk proses pengembalian dana",
              ),

              _buildSection(
                title: "6. Hak Kekayaan Intelektual",
                content:
                    "• Semua konten dalam aplikasi DreamTix dilindungi oleh hak cipta\n• Anda tidak diperkenankan untuk menyalin, memodifikasi, atau mendistribusikan konten tanpa izin tertulis\n• Logo, nama, dan merek dagang DreamTix adalah milik PT. DreamTix Indonesia\n• Pelanggaran terhadap hak kekayaan intelektual dapat dikenakan tindakan hukum",
              ),

              _buildSection(
                title: "7. Privasi dan Perlindungan Data",
                content:
                    "• Kami berkomitmen untuk melindungi data pribadi Anda\n• Penggunaan data pribadi sesuai dengan Kebijakan Privasi yang berlaku\n• Data transaksi akan disimpan untuk keperluan administrasi dan audit\n• Kami tidak akan membagikan data pribadi kepada pihak ketiga tanpa persetujuan Anda",
              ),

              _buildSection(
                title: "8. Larangan Penggunaan",
                content:
                    "Anda dilarang untuk:\n• Menggunakan layanan untuk tujuan yang melanggar hukum\n• Melakukan aktivitas yang dapat merusak sistem atau server\n• Menyebarkan virus, malware, atau kode berbahaya lainnya\n• Melakukan pemalsuan identitas atau informasi\n• Menggunakan bot atau sistem otomatis untuk membeli tiket dalam jumlah besar",
              ),

              _buildSection(
                title: "9. Batasan Tanggung Jawab",
                content:
                    "• DreamTix tidak bertanggung jawab atas kerugian langsung atau tidak langsung\n• Kami tidak menjamin ketersediaan layanan 100% tanpa gangguan\n• Tanggung jawab kami terbatas pada nilai transaksi yang dilakukan\n• Kami tidak bertanggung jawab atas tindakan atau kelalaian pihak bioskop mitra",
              ),

              _buildSection(
                title: "10. Perubahan Syarat dan Ketentuan",
                content:
                    "• Kami berhak mengubah syarat dan ketentuan ini sewaktu-waktu\n• Perubahan akan diberitahukan melalui aplikasi atau email\n• Penggunaan layanan setelah perubahan berarti Anda menyetujui syarat yang baru\n• Disarankan untuk memeriksa syarat dan ketentuan secara berkala",
              ),

              _buildSection(
                title: "11. Penyelesaian Sengketa",
                content:
                    "• Segala sengketa akan diselesaikan melalui musyawarah mufakat\n• Jika musyawarah tidak tercapai, sengketa akan diselesaikan melalui arbitrase\n• Hukum yang berlaku adalah hukum Republik Indonesia\n• Pengadilan yang berwenang adalah Pengadilan Negeri Jakarta Selatan",
              ),

              const SizedBox(height: 30),

              // Contact Information
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
                      "Hubungi Kami",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Jika Anda memiliki pertanyaan mengenai syarat dan ketentuan ini, silakan hubungi kami:",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(Icons.email, "dreamtix@gmail.com"),
                    _buildContactItem(Icons.phone, "+62 838 7191 7600"),
                    _buildContactItem(Icons.location_on, "Jember, Indonesia"),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 16),
          const SizedBox(width: 12),
          Text(
            info,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
