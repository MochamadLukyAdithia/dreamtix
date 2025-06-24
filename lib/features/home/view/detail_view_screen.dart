import 'package:dreamtix/features/home/controller/DetailEventController.dart';
import 'package:dreamtix/features/home/controller/GpsController.dart';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:dreamtix/features/home/model/tiket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:dreamtix/core/helper/date.dart' as date;

class DetailEventScreen extends StatelessWidget {
  final EventModel event;
  DetailEventScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Initialize controller with event data
    final controller =
        Get.put(DetailEventController(eventData: event), permanent: false);

    return Scaffold(
      backgroundColor: Color(0xFF0D0C2D),
      body: CustomScrollView(
        slivers: [
          EventImageAppBar(event: event),
          SliverToBoxAdapter(
            child: EventContent(event: event),
          ),
        ],
      ),
      bottomNavigationBar: BuyTicketButton(
        event: event,
      ),
    );
  }
}

class EventImageAppBar extends StatelessWidget {
  final EventModel event;

  const EventImageAppBar({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
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

class EventContent extends StatelessWidget {
  final EventModel event;
  EventContent({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventTitle(event: event),
          SizedBox(height: 16),
          EventInfoCards(
            event: event,
          ),
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

class EventTitle extends StatelessWidget {
  final EventModel event;
  EventTitle({required this.event});

  @override
  Widget build(BuildContext context) {
    return Text(
      event.nameEvent,
      style: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class EventInfoCards extends StatelessWidget {
  final EventModel event;
  EventInfoCards({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EventInfoCard(
          icon: Icons.calendar_today,
          title: "Tanggal & Waktu",
          content: date.formatDate(event.waktu),
        ),
        SizedBox(height: 12),
        EventInfoCard(
          icon: Icons.person,
          title: "Artis",
          content: event.artis,
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
}

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
          EventFacilities(),
        ],
      ),
    );
  }
}

class EventFacilities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final facilities = [
      "Parking area yang luas",
      "Food court dan minuman",
      "Security 24 jam",
      "Toilet bersih",
      "Area merchandise",
    ];

    return Column(
      children: facilities
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
          .toList(),
    );
  }
}

class BuyTicketButton extends GetView<DetailEventController> {
  final EventModel event;
  BuyTicketButton({required this.event});

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
          onPressed: () {
            controller.showTicketBottomSheet();
          },
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

class TicketBottomSheet extends GetView<DetailEventController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Pilih Jenis Tiket",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              if (controller.isLoadingTickets.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.tickets.isEmpty) {
                return Text(
                  "Tidak ada tiket tersedia",
                  style: TextStyle(color: Colors.grey),
                );
              }

              return Column(
                children: controller.tickets
                    .map((ticket) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TicketOption(ticket: ticket),
                        ))
                    .toList(),
              );
            }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TicketOption extends GetView<DetailEventController> {
  final Tiket ticket;

  const TicketOption({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0D0C2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.category.nama,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ticket.category.posisi,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${CurrencyFormatter.formatRupiah(ticket.harga)}",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size(0, 0),
                ),
                onPressed: () => controller.selectTicket(ticket),
                child: Text(
                  "Pilih",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurrencyFormatter {
  static String formatRupiah(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

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
//           if (GpsController().currentPosition.value == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: GpsController().currentPosition.value!,
//               zoom: 15,
//             ),
//             onMapCreated: GpsController().onMapCreated,
//             markers: GpsController().marker.value != null
//                 ? {GpsController().marker.value!}
//                 : {},
//             myLocationEnabled: true,
//           );
//         }),
//       ),
//     );
//   }
// }

class EventMapSection extends GetView<DetailEventController> {
  final GpsController gpsController =
      Get.put(GpsController()); // Properly initialize controller

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[800],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Obx(() {
          // Show loading state
          if (gpsController.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Getting location...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          // Show error state with retry option
          if (gpsController.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Maps unavailable',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    gpsController.errorMessage.value,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => gpsController.refreshLocation(),
                        icon: Icon(Icons.refresh, size: 16),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => gpsController.openInMaps(),
                        icon: Icon(Icons.open_in_new, size: 16),
                        label: Text('Open Maps'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          // Show maps when location is available
          if (gpsController.currentPosition.value != null) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: gpsController.currentPosition.value!,
                    zoom: 16,
                  ),
                  onMapCreated: gpsController.onMapCreated,
                  markers: gpsController.marker.value != null
                      ? {gpsController.marker.value!}
                      : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                ),
                // Floating action button to open in external maps
                Positioned(
                  top: 8,
                  right: 8,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: () => gpsController.openInMaps(),
                    child:
                        Icon(Icons.open_in_new, color: Colors.blue, size: 20),
                    heroTag: "open_maps_btn", // Unique hero tag
                  ),
                ),
              ],
            );
          }

          // Fallback loading state
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }),
      ),
    );
  }
}
