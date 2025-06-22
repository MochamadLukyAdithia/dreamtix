import 'package:dreamtix/features/home/controller/HomeTabController.dart';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:dreamtix/features/home/view/detail_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

// Search Bar Widget
class SearchBar extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return TextField(
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

// Banner Section Widget
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

// Banner Carousel Widget
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

// Banner Item Widget
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

// Banner Indicators Widget
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

// Banner Error Widget
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

// Banner Empty Widget
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

// Event Section Widget
class EventSection extends GetView<HomeTabController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventSectionHeader(),
        SizedBox(height: 12),
        EventList(),
      ],
    );
  }
}

// Event Section Header Widget
class EventSectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Event",
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Event List Widget
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

// Event Loading Widget
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

// Event Error Widget
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

// Event Empty Widget
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

// Event Card Widget
class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeTabController>();

    return GestureDetector(
      onTap: () => controller.navigateToDetail(event),
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

// Event Card Image Widget
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

// Event Card Content Widget
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
            text: _formatDate(event.waktu),
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

  String _formatDate(String dateString) {
    try {
      final dateUtc = DateTime.parse(dateString);
      final localDate = dateUtc.toLocal();
      return DateFormat('EEEE, dd MMMM yyyy - HH:mm', 'id_ID')
          .format(localDate);
    } catch (e) {
      return dateString;
    }
  }
}

// Event Card Title Widget
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

// Event Card Info Widget
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
