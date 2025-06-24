class QrModel {
  final String kodeQr;
  final bool isUsed;
  final int idTiket;
  final String qrUrl;

  QrModel({
    required this.kodeQr,
    required this.isUsed,
    required this.idTiket,
    required this.qrUrl,
  });

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
      kodeQr: json['kode_qr'],
      isUsed: json['is_used'],
      idTiket: json['id_tiket'],
      qrUrl: json['qr_url'],
    );
  }
}
