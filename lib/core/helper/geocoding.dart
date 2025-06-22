import 'package:geocoding/geocoding.dart';

Future<void> getCoordinatesFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);

    if (locations.isNotEmpty) {
      final lat = locations.first.latitude;
      final lng = locations.first.longitude;
      print('Latitude: $lat, Longitude: $lng');
    }
  } catch (e) {
    print('Error: $e');
  }
}
