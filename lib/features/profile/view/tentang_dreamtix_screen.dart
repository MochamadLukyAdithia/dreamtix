import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TentangDreamTixScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E21),
      appBar: AppBar(
        title: const Text("Tentang DreamTix",
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
              // Logo and App Name
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.movie,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "DreamTix",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Versi 1.0.0",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Tentang, Visi, Misi
              _buildSection(
                title: "Tentang Aplikasi",
                content:
                    "DreamTix adalah platform pembelian tiket bioskop terdepan di Indonesia. Kami hadir dengan misi untuk memberikan pengalaman menonton film yang tak terlupakan bagi seluruh masyarakat Indonesia.\n\nDengan interface yang user-friendly dan fitur-fitur canggih, DreamTix memudahkan Anda untuk memesan tiket bioskop favorit dengan cepat dan mudah.",
              ),
              _buildSection(
                title: "Visi Kami",
                content:
                    "Menjadi platform digital terdepan yang menghubungkan pecinta film dengan pengalaman sinema terbaik di seluruh Indonesia.",
              ),
              _buildSection(
                title: "Misi Kami",
                content:
                    "• Menyediakan layanan pemesanan tiket yang mudah dan terpercaya\n• Memberikan informasi film yang lengkap dan akurat\n• Menghadirkan promo dan penawaran menarik untuk pelanggan\n• Mendukung industri perfilman Indonesia",
              ),

              // Features Section
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
                      "Fitur Unggulan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                        Icons.local_movies, "Koleksi Film Terlengkap"),
                    _buildFeatureItem(
                        Icons.location_on, "Jaringan Bioskop Luas"),
                    _buildFeatureItem(Icons.payment, "Pembayaran Aman & Mudah"),
                    _buildFeatureItem(Icons.discount, "Promo Menarik"),
                    _buildFeatureItem(
                        Icons.support_agent, "Customer Service 24/7"),
                    _buildFeatureItem(Icons.star, "Review & Rating Film"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Informasi Perusahaan
              _buildSection(
                title: "Informasi Perusahaan",
                content:
                    "PT. DreamTix Indonesia\nJl. Technology Valley No. 123\nJakarta Selatan, 12345\nIndonesia",
              ),

              // Hubungi Kami
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
                    const SizedBox(height: 16),
                    _buildContactItem(Icons.email, "info@dreamtix.com"),
                    _buildContactItem(Icons.phone, "+62 21 1234 5678"),
                    _buildContactItem(Icons.language, "www.dreamtix.com"),
                    _buildContactItem(Icons.facebook, "@DreamTixOfficial"),
                    _buildContactItem(Icons.camera_alt, "@dreamtix_id"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Copyright & Social Media
              Center(
                child: Column(
                  children: [
                    const Text(
                      "© 2024 DreamTix Indonesia",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Semua hak dilindungi",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(Icons.facebook),
                        const SizedBox(width: 16),
                        _buildSocialIcon(Icons.camera_alt),
                        const SizedBox(width: 16),
                        _buildSocialIcon(Icons.play_arrow),
                        const SizedBox(width: 16),
                        _buildSocialIcon(Icons.alternate_email),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
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
              fontSize: 18,
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

  Widget _buildFeatureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
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

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Icon(icon, color: Colors.red, size: 20),
    );
  }
}
