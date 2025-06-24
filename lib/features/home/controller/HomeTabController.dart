import 'dart:async';
import 'package:dreamtix/features/home/controller/HomeController.dart';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:dreamtix/features/home/model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTabController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  // Observable variables
  var bannerImages = <String>[].obs;
  var events = <EventModel>[].obs;
  var isLoadingBanners = true.obs;
  var isLoadingEvents = true.obs;
  var hasErrorBanners = false.obs;
  var hasErrorEvents = false.obs;
  var errorMessageBanners = ''.obs;
  var errorMessageEvents = ''.obs;

  // Banner carousel
  late PageController pageController;
  var currentPage = 0.obs;
  Timer? bannerTimer;

  // Search
  var searchText = ''.obs;
  var filteredEvents = <EventModel>[].obs;
  TextEditingController? searchController; // Tambahkan ini jika diperlukan

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    searchController = TextEditingController(); // Initialize search controller
    loadInitialData();
  }

  @override
  void onClose() {
    bannerTimer?.cancel();
    pageController.dispose();
    searchController?.dispose(); // Dispose search controller
    super.onClose();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadBanners(),
      loadEvents(),
    ]);
  }

  Future<void> loadBanners() async {
    try {
      isLoadingBanners.value = true;
      hasErrorBanners.value = false;

      final banners = await homeController.getBanners();
      bannerImages.value = banners.map((b) => b.image).toList();

      if (bannerImages.isNotEmpty) {
        startBannerTimer();
      }
    } catch (e) {
      hasErrorBanners.value = true;
      errorMessageBanners.value = e.toString();
      Get.snackbar('Error', 'Gagal memuat banner: $e');
    } finally {
      isLoadingBanners.value = false;
    }
  }

  Future<void> loadEvents() async {
    try {
      isLoadingEvents.value = true;
      hasErrorEvents.value = false;

      final eventList = await homeController.getEvents();
      events.value = eventList;
      filteredEvents.value = eventList;
    } catch (e) {
      hasErrorEvents.value = true;
      errorMessageEvents.value = e.toString();
      Get.snackbar('Error', 'Gagal memuat event: $e');
    } finally {
      isLoadingEvents.value = false;
    }
  }

  void startBannerTimer() {
    bannerTimer?.cancel();
    bannerTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (pageController.hasClients && bannerImages.isNotEmpty) {
        currentPage.value = (currentPage.value + 1) % bannerImages.length;
        pageController.animateToPage(
          currentPage.value,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void updateSearch(String text) {
    searchText.value = text;
    homeController.updateSearch(text);
    filterEvents();
  }

  // Method baru untuk menangani pencarian ketika Enter ditekan
  void performSearch(String query) {
    searchText.value = query.trim();
    homeController.updateSearch(query.trim());
    filterEvents();
    // Feedback untuk user bahwa pencarian dilakukan
    if (query.trim().isNotEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Mencari: "${query.trim()}"',
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red.withOpacity(0.8),
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
          borderRadius: 8,
        ),
      );
    }
  }

  // Method baru untuk menghapus pencarian
  void clearSearch() {
    searchText.value = '';
    searchController?.clear();
    homeController.updateSearch('');
    filteredEvents.value = events; // Reset ke semua events
  }

  void filterEvents() {
    if (searchText.value.isEmpty) {
      filteredEvents.value = events;
    } else {
      filteredEvents.value = events.where((event) {
        final searchLower = searchText.value.toLowerCase();
        return event.nameEvent.toLowerCase().contains(searchLower) ||
            event.artis.toLowerCase().contains(searchLower) ||
            // Tambahan pencarian berdasarkan lokasi jika diperlukan
            'seven dream city jember'.toLowerCase().contains(searchLower);
      }).toList();
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> refreshData() async {
    // Pastikan banner dan events dimuat ulang bersamaan
    await Future.wait([
      loadBanners(),
      loadEvents(),
    ]);

    // Jika ada pencarian aktif, lakukan filter ulang
    if (searchText.value.isNotEmpty) {
      filterEvents();
    }
  }

  void retryLoadBanners() {
    loadBanners();
  }

  void retryLoadEvents() {
    loadEvents();
  }

  void navigateToDetail(EventModel event) {
    print("EVENT ${event.artis}");
    Get.toNamed('/detail-event', arguments: event);
  }

  // Method tambahan untuk mendapatkan status pencarian
  bool get isSearching => searchText.value.isNotEmpty;

  // Method untuk mendapatkan jumlah hasil pencarian
  int get searchResultCount => filteredEvents.length;
}
