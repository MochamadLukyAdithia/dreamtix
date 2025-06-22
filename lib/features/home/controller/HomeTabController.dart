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

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    loadInitialData();
  }

  @override
  void onClose() {
    bannerTimer?.cancel();
    pageController.dispose();
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

  void filterEvents() {
    if (searchText.value.isEmpty) {
      filteredEvents.value = events;
    } else {
      filteredEvents.value = events.where((event) {
        return event.nameEvent.toLowerCase().contains(searchText.value.toLowerCase()) ||
               event.artis.toLowerCase().contains(searchText.value.toLowerCase());
      }).toList();
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> refreshData() async {
    await loadInitialData();
  }

  void retryLoadBanners() {
    loadBanners();
  }

  void retryLoadEvents() {
    loadEvents();
  }

  void navigateToDetail(EventModel event) {
    Get.toNamed('/detail-event', arguments: event);
  }
}