import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GpsController extends GetxController {
  var currentPosition = Rxn<LatLng>();
  var isLoading = false.obs;
  var marker = Rxn<Marker>();
  GoogleMapController? mapController;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        hasError.value = true;
        errorMessage.value = 'Location services are disabled.';
        Get.snackbar('Error', 'Location services are disabled.');
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          hasError.value = true;
          errorMessage.value = 'Location permissions are denied';
          Get.snackbar('Error', 'Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        hasError.value = true;
        errorMessage.value = 'Location permissions are permanently denied';
        Get.snackbar('Error', 'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10), // Add timeout
        ),
      );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      
      // Create marker
      marker.value = Marker(
        markerId: MarkerId("current_location"),
        position: currentPosition.value!,
        infoWindow: InfoWindow(title: "Lokasi Saat Ini"),
      );

      // Move camera if map is ready
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentPosition.value!, 16),
        );
      }

      print("Current location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to get location: $e';
      Get.snackbar('Error', 'Failed to get current location: $e');
      print("Error getting location: $e");
      
      // Set default location (Jakarta) as fallback
      currentPosition.value = LatLng(-6.2088, 106.8456);
      marker.value = Marker(
        markerId: MarkerId("default_location"),
        position: currentPosition.value!,
        infoWindow: InfoWindow(title: "Default Location"),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Move camera to current position when map is created
    if (currentPosition.value != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(currentPosition.value!, 16),
        );
      });
    }
  }

  // Method to open in external maps app
  Future<void> openInMaps() async {
    if (currentPosition.value != null) {
      final lat = currentPosition.value!.latitude;
      final lng = currentPosition.value!.longitude;
      
      // Try Google Maps first
      final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      
      try {
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
        } else {
          // Fallback to generic maps URL
          final fallbackUrl = 'https://maps.google.com/?q=$lat,$lng';
          await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        Get.snackbar('Error', 'Could not open maps application');
      }
    }
  }

  Future<void> refreshLocation() async {
    await getCurrentLocation();
  }
}
