import 'package:dreamtix/features/home/controller/HomeTabController.dart';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:dreamtix/features/home/view/detail_view_screen.dart';
import 'package:dreamtix/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dreamtix/core/helper/date.dart' as date;

class HomeTab extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeTabController());

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: Colors.red,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SearchBar(),
            SizedBox(height: 16),
            BannerSection(),
            SizedBox(height: 24),
            EventSection(),
          ],
        ),
      ),
    );
  }
}

// Search Bar Widget dengan perubahan untuk menampilkan status pencarian
class SearchBar extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller.searchController,
          onChanged: controller.updateSearch,
          onSubmitted: (value) {
            // Tambahkan aksi ketika Enter ditekan
            controller.performSearch(value);
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Cari berdasarkan artis, acara atau nama tempat",
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color(0xFF1B1A47),
            suffixIcon: Obx(() => controller.searchText.value.isNotEmpty
                ? GestureDetector(
                    onTap: () => controller.clearSearch(),
                    child: Icon(Icons.clear, color: Colors.white),
                  )
                : Icon(Icons.search, color: Colors.white)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        // Tampilkan indikator pencarian aktif
        Obx(() {
          if (controller.searchText.value.isNotEmpty) {
            return Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 14, color: Colors.red),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Mencari: "${controller.searchText.value}"',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => controller.clearSearch(),
                    child: Icon(Icons.close, size: 14, color: Colors.red),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        }),
      ],
    );
  }
}

// Banner Section Widget - Tetap sama, tidak berubah
class BannerSection extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BannerCarousel(),
        SizedBox(height: 8),
        BannerIndicators(),
      ],
    );
  }
}

// Banner Carousel Widget - Tetap sama
class BannerCarousel extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Obx(() {
        if (controller.isLoadingBanners.value) {
          return Center(child: CircularProgressIndicator(color: Colors.red));
        }

        if (controller.hasErrorBanners.value) {
          return BannerErrorWidget();
        }

        if (controller.bannerImages.isEmpty) {
          return BannerEmptyWidget();
        }

        return PageView.builder(
          controller: controller.pageController,
          itemCount: controller.bannerImages.length,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (_, index) {
            return BannerItem(imageUrl: controller.bannerImages[index]);
          },
        );
      }),
    );
  }
}

// Banner Item Widget - Tetap sama
class BannerItem extends StatelessWidget {
  final String imageUrl;

  const BannerItem({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (error, stackTrace) {
            // Handle image loading error
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.1),
        ),
      ),
    );
  }
}

// Banner Indicators Widget - Tetap sama
class BannerIndicators extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.bannerImages.isEmpty) return SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.bannerImages.length,
          (index) => Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.currentPage.value == index
                  ? Colors.red
                  : Colors.grey,
            ),
          ),
        ),
      );
    });
  }
}

// Banner Error Widget - Tetap sama
class BannerErrorWidget extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1B1A47),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 32),
            SizedBox(height: 8),
            Text(
              "Gagal memuat banner",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: controller.retryLoadBanners,
              child: Text("Coba Lagi", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

// Banner Empty Widget - Tetap sama
class BannerEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1B1A47),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, color: Colors.grey, size: 32),
            SizedBox(height: 8),
            Text(
              "Tidak ada banner tersedia",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Event Section Widget dengan header yang disesuaikan
class EventSection extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => EventSectionHeader(
              isSearching: controller.searchText.value.isNotEmpty,
              resultCount: controller.filteredEvents.length,
            )),
        SizedBox(height: 12),
        EventList(),
      ],
    );
  }
}

// Event Section Header Widget dengan informasi pencarian
class EventSectionHeader extends StatelessWidget {
  final bool isSearching;
  final int resultCount;

  const EventSectionHeader({
    Key? key,
    required this.isSearching,
    required this.resultCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isSearching ? "Hasil Pencarian" : "Event",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isSearching)
          Text(
            "$resultCount event ditemukan",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}

// Event List Widget - Tetap sama
class EventList extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingEvents.value) {
        return EventLoadingWidget();
      }

      if (controller.hasErrorEvents.value) {
        return EventErrorWidget();
      }

      if (controller.filteredEvents.isEmpty) {
        return EventEmptyWidget();
      }

      return Column(
        children: controller.filteredEvents
            .map((event) => EventCard(event: event))
            .toList(),
      );
    });
  }
}

// Event Loading Widget - Tetap sama
class EventLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(color: Colors.red),
      ),
    );
  }
}

// Event Error Widget - Tetap sama
class EventErrorWidget extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 8),
          Text(
            "Gagal memuat event",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            controller.errorMessageEvents.value,
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.retryLoadEvents,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Coba Lagi", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Event Empty Widget - Tetap sama
class EventEmptyWidget extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.event_busy, color: Colors.grey, size: 48),
          SizedBox(height: 8),
          Text(
            controller.searchText.value.isEmpty
                ? "Tidak ada event tersedia"
                : "Tidak ada event yang sesuai dengan pencarian",
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Event Card Widget - Tetap sama
class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeTabController>();

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoute.detailEvent,
        arguments: event,
      ),
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
            EventCardImage(imageUrl: event.image),
            EventCardContent(event: event),
          ],
        ),
      ),
    );
  }
}

// Event Card Image Widget - Tetap sama
class EventCardImage extends StatelessWidget {
  final String imageUrl;

  const EventCardImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        height: 180,
        width: double.infinity,
        child: Image.network(
          imageUrl,
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
    );
  }
}

// Event Card Content Widget - Tetap sama
class EventCardContent extends StatelessWidget {
  final EventModel event;

  const EventCardContent({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventCardTitle(title: event.nameEvent),
          SizedBox(height: 8),
          EventCardInfo(
            icon: Icons.calendar_today,
            text: date.formatDate(event.waktu),
          ),
          SizedBox(height: 4),
          EventCardInfo(
            icon: Icons.person,
            text: event.artis,
          ),
          SizedBox(height: 4),
          EventCardInfo(
            icon: Icons.location_on,
            text: "Seven Dream City, Jember",
          ),
        ],
      ),
    );
  }
}

// Event Card Title Widget - Tetap sama
class EventCardTitle extends StatelessWidget {
  final String title;

  const EventCardTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// Event Card Info Widget - Tetap sama
class EventCardInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const EventCardInfo({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
