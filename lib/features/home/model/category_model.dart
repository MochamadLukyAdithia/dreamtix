class Category {
  final int idCategory;
  final String nama;
  final String posisi;

  Category({
    required this.idCategory,
    required this.nama,
    required this.posisi,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        idCategory: json['id_category'] is int
            ? json['id_category']
            : int.tryParse(json['id_category'].toString()) ?? 0,
        nama: json['nama'] ?? '',
        posisi: json['posisi'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id_category': idCategory,
        'nama': nama,
        'posisi': posisi,
      };
}
