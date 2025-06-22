import 'package:dreamtix/features/home/model/tiket_model.dart';

class DetailPemesanan {
  final int quantity;
  final int total;
  final Tiket tiket;

  DetailPemesanan({
    required this.quantity,
    required this.total,
    required this.tiket,
  });

  factory DetailPemesanan.fromJson(Map<String, dynamic> json) {
    return DetailPemesanan(
      quantity: json['quantity'],
      total: json['total'],
      tiket: Tiket.fromJson(json['tiket']),
    );
  }

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'total': total,
        'tiket': tiket.toJson(),
      };
}