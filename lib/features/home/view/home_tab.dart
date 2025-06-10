import 'package:dreamtix/core/theme/network.dart';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:dreamtix/features/home/view/detail_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:dreamtix/features/home/controller/HomeController.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final controller = Get.find<HomeController>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _bannerTimer;
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();

    // Ambil data event dari controller
    _eventsFuture = controller.getEvents();

    // Start banner auto-scroll timer
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && mounted) {
        _currentPage =
            (_currentPage + 1) % NetworkImageAssets.bannerImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Search bar
          TextField(
            onChanged: controller.updateSearch,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Cari berdasarkan artis, acara atau nama tempat",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFF1B1A47),
              suffixIcon: Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          SizedBox(height: 16),

          // Banner
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              itemCount: NetworkImageAssets.bannerImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (_, i) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(NetworkImageAssets.bannerImages[i]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),

          // Banner indicators
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              NetworkImageAssets.bannerImages.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),

          SizedBox(height: 24),

          // Event section
          Text("Event",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 12),

          FutureBuilder<List<EventModel>>(
            future: _eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 8),
                      Text("Gagal memuat event",
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                      SizedBox(height: 4),
                      Text("${snapshot.error}",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _eventsFuture = controller.getEvents();
                          });
                        },
                        child: Text("Coba Lagi"),
                      ),
                    ],
                  ),
                );
              }

              final events = snapshot.data ?? [];

              if (events.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, color: Colors.grey, size: 48),
                      SizedBox(height: 8),
                      Text("Tidak ada event tersedia",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                );
              }

              return Column(
                children: events.map((event) => _eventCard(event)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _eventCard(EventModel event) {
    return GestureDetector(
      onTap: () {
        // Pass the actual event data to DetailEventScreen
        Get.to(() => DetailEventScreen(event: event));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Color(0xFF1B1A47),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  event.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name_event,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _formatDate(event.waktu),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),

                  // Artist
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.artis,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Seven Dream City, Jember",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }
}
