import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GpsController extends GetxController {
  var currentPosition = Rxn<LatLng>();
  var isLoading = false.obs;
  var marker = Rxn<Marker>();
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled.');
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      
      // Create marker
      marker.value = Marker(
        markerId: MarkerId("current_location"),
        position: currentPosition.value!,
        infoWindow: InfoWindow(title: "Lokasi Saat Ini"),
      );

      // Move camera to current position
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
        );
      }

      print("Current location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
      print("Error getting location: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition.value != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
      );
    }
  }
}