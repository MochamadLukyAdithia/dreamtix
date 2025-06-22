class EventModel {
  final int idEvent;
  final String nameEvent;
  final String waktu;
  final String artis;
  final String image;

  EventModel({
    required this.idEvent,
    required this.nameEvent,
    required this.waktu,
    required this.artis,
    required this.image,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      idEvent: map['id_event'] is int
          ? map['id_event']
          : int.tryParse(map['id_event'].toString()) ?? 0,
      nameEvent: map['nama_event'] ?? '',
      waktu: DateTime.tryParse(map['waktu'] ?? '').toString(),
      artis: map['artis'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_event': idEvent,
        'nama_event': nameEvent,
        'waktu': waktu.toString(),
        'artis': artis,
        'image': image,
      };
}
