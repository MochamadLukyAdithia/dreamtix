import 'package:dreamtix/features/home/controller/DetailEventController.dart';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DetailEventScreen extends GetView<DetailEventController> {
  @override
  Widget build(BuildContext context) {
    Get.put(DetailEventController());

    return Scaffold(
      backgroundColor: Color(0xFF0D0C2D),
      body: CustomScrollView(
        slivers: [
          EventImageAppBar(event: controller.event),
          SliverToBoxAdapter(
            child: EventContent(),
          ),
        ],
      ),
      bottomNavigationBar: BuyTicketButton(),
    );
  }
}

// Separate Widget for App Bar with Image
class EventImageAppBar extends StatelessWidget {
  final EventModel event;

  const EventImageAppBar({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.toNamed("home"),
      ),
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Color(0xFF0D0C2D),
      foregroundColor: Colors.white,
      title: Text("Detail Event"),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              event.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
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
                  color: Colors.grey[800],
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
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate Widget for Event Content
class EventContent extends GetView<DetailEventController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventTitle(),
          SizedBox(height: 16),
          EventInfoCards(),
          SizedBox(height: 24),
          // EventMapSection(),
          SizedBox(height: 24),
          EventTabSection(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Widget for Event Title
class EventTitle extends GetView<DetailEventController> {
  @override
  Widget build(BuildContext context) {
    return Text(
      controller.event.nameEvent,
      style: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Widget for Event Info Cards
class EventInfoCards extends GetView<DetailEventController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EventInfoCard(
          icon: Icons.calendar_today,
          title: "Tanggal & Waktu",
          content: _formatDateTime(controller.event.waktu),
        ),
        SizedBox(height: 12),
        EventInfoCard(
          icon: Icons.person,
          title: "Artis",
          content: controller.event.artis,
        ),
        SizedBox(height: 12),
        EventInfoCard(
          icon: Icons.location_on,
          title: "Lokasi",
          content: "Seven Dream City, Jember",
        ),
      ],
    );
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy • HH:mm', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

// Reusable Widget for Info Card
class EventInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const EventInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1B1A47),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.red, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// // Widget for Map Section
// class EventMapSection extends GetView<DetailEventController> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.grey[800],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Obx(() {
//           if (controller.gpsController.currentPosition.value == null) {
//             return Center(child: CircularProgressIndicator());
//           }

//           return GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: controller.gpsController.currentPosition.value!,
//               zoom: 15,
//             ),
//             onMapCreated: controller.gpsController.onMapCreated,
//             markers: controller.gpsController.marker.value != null
//                 ? {controller.gpsController.marker.value!}
//                 : {},
//             myLocationEnabled: true,
//           );
//         }),
//       ),
//     );
//   }
// }

// Widget for Tab Section
class EventTabSection extends GetView<DetailEventController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF1B1A47),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: controller.tabController,
            indicator: BoxDecoration(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Deskripsi"),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: TabBarView(
            controller: controller.tabController,
            children: [
              EventDescription(),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget for Event Description
class EventDescription extends GetView<DetailEventController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tentang Event",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Nikmati pengalaman musik yang tak terlupakan dengan ${controller.event.artis} di ${controller.event.nameEvent}. Event ini akan menghadirkan pertunjukan spektakuler dengan sound system berkualitas tinggi dan lighting yang memukau.\n\nBergabunglah dengan ribuan penggemar musik untuk merasakan atmosfer yang luar biasa di Seven Dream City, Jember. Jangan lewatkan kesempatan emas ini!",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Fasilitas:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          ...EventFacilities().buildFacilityList(),
        ],
      ),
    );
  }
}

// Widget for Event Facilities
class EventFacilities {
  List<Widget> buildFacilityList() {
    final facilities = [
      "Parking area yang luas",
      "Food court dan minuman",
      "Security 24 jam",
      "Toilet bersih",
      "Area merchandise",
    ];

    return facilities
        .map((facility) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text(
                    facility,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ))
        .toList();
  }
}

// Widget for Buy Ticket Button
class BuyTicketButton extends GetView<DetailEventController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0D0C2D),
        border: Border(top: BorderSide(color: Colors.grey[800]!, width: 0.5)),
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: controller.showTicketBottomSheet,
          child: Text(
            "Beli Tiket",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
