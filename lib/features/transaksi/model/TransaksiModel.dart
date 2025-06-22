import 'package:dreamtix/core/theme/network.dart';
import 'package:dreamtix/features/transaksi/model/DetailModel.dart';

class TransaksiModel {
  final int idCustomer;
  final int idPemesanan;
  final String tanggalFormatted;
  final List<DetailPemesanan> detailPemesanan;
  final List<Transaksi> transaksis;

  TransaksiModel({
    required this.idCustomer,
    required this.idPemesanan,
    required this.tanggalFormatted,
    required this.detailPemesanan,
    required this.transaksis,
  });

  factory TransaksiModel.fromJson(
    Map<String, dynamic> json,
    String Function(String) dateFormatter,
  ) {
    return TransaksiModel(
      idCustomer: json['id_customer'],
      idPemesanan: json['id_pesan'],
      tanggalFormatted: dateFormatter(json['tanggal']),
      detailPemesanan: (json['detailPemesanan'] as List)
          .map((e) => DetailPemesanan.fromJson(e))
          .toList(),
      transaksis: (json['transaksis'] as List)
          .map((e) => Transaksi.fromJson(e))
          .toList(),
    );
  }

  String get title => detailPemesanan[0].tiket.category.nama;
  String get metode => transaksis[0].metodePembayaran.nama;
  String get status => transaksis[0].status;
  String get date => tanggalFormatted;
  String get id => idPemesanan.toString();
  String get imageUrl => NetworkImageAssets.bannerImage[0]; // default image
}



class Transaksi {
  final int idMetode;
  final String status;
  final MetodePembayaran metodePembayaran;

  Transaksi({
    required this.idMetode,
    required this.status,
    required this.metodePembayaran,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      idMetode: json['id_metode'],
      status: json['status'],
      metodePembayaran: MetodePembayaran.fromJson(json['metodePembayaran']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_metode': idMetode,
        'status': status,
        'metodePembayaran': metodePembayaran.toJson(),
      };
}

class MetodePembayaran {
  final String nama;

  MetodePembayaran({required this.nama});

  factory MetodePembayaran.fromJson(Map<String, dynamic> json) {
    return MetodePembayaran(nama: json['nama']);
  }

  Map<String, dynamic> toJson() => {'nama': nama};
}