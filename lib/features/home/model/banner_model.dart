
// Ganti dengan model BannerModel sesuai struktur datamu
class BannerModel {
  final int idBanner;
  final String image;

  BannerModel({required this.idBanner, required this.image});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      idBanner: json['id_banner'],
      image: json['image'],
    );
  }
}