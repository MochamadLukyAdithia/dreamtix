class EventModel {
  final String name_event;
  final String waktu;
  final String artis;
  final String image;

  EventModel({
    required this.name_event,
    required this.waktu,
    required this.artis,
    required this.image,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      name_event: map['name_event'] ?? '',
      waktu: map['waktu'] ?? '',
      artis: map['artis'] ?? '',
      image: map['image'] ?? '',
    );
  }
}
