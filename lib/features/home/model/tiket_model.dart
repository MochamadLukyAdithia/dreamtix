import 'package:dreamtix/features/home/model/category_model.dart';
import 'package:dreamtix/features/home/model/event_model.dart';

class Tiket {
  final int idTiket;
  final int idCategory;
  final int idEvent;
  final int harga;
  final int stok;
  final EventModel event;
  final Category category;

  Tiket({
    required this.idTiket,
    required this.idCategory,
    required this.idEvent,
    required this.harga,
    required this.stok,
    required this.event,
    required this.category,
  });

  factory Tiket.fromJson(Map<String, dynamic> json) => Tiket(
        idTiket: json['id_tiket'] is int
            ? json['id_tiket']
            : int.tryParse(json['id_tiket'].toString()) ?? 0,
        idCategory: json['id_category'] is int
            ? json['id_category']
            : int.tryParse(json['id_category'].toString()) ?? 0,
        idEvent: json['id_event'] is int
            ? json['id_event']
            : int.tryParse(json['id_event'].toString()) ?? 0,
        harga: json['harga'] is int
            ? json['harga']
            : int.tryParse(json['harga'].toString()) ?? 0,
        stok: json['stok'] is int
            ? json['stok']
            : int.tryParse(json['stok'].toString()) ?? 0,
        event: EventModel.fromMap(json['event'] ?? {}),
        category: Category.fromJson(json['category'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'id_tiket': idTiket,
        'id_category': idCategory,
        'id_event': idEvent,
        'harga': harga,
        'stok': stok,
        'event': event.toJson(),
        'category': category.toJson(),
      };
}
