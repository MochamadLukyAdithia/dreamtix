import 'package:dreamtix/features/home/controller/HomeController.dart';
import 'package:dreamtix/features/home/controller/GpsController.dart';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:dreamtix/features/home/model/tiket_model.dart';
import 'package:dreamtix/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailEventController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late EventModel event;
  late TabController tabController;
  var selectedTab = 0.obs;
  var isLoadingTickets = false.obs;
  var tickets = <Tiket>[].obs;

  final HomeController homeController = Get.find<HomeController>();
  final GpsController gpsController = Get.put(GpsController());

  @override
  void onInit() {
    super.onInit();
    event = Get.arguments as EventModel;
    tabController = TabController(length: 1, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> loadTickets() async {
    try {
      isLoadingTickets.value = true;
      final result = await homeController.getTiketsByEventId(event.idEvent);
      tickets.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat tiket: $e');
    } finally {
      isLoadingTickets.value = false;
    }
  }

  void showTicketBottomSheet() async {
    await loadTickets();
    Get.bottomSheet(
      TicketBottomSheet(),
      backgroundColor: Color(0xFF1B1A47),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void selectTicket(Tiket ticket) {
    Get.toNamed(AppRoute.beliTiket, arguments: ticket);
  }

  void showSuccessDialog(String ticketType) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF1B1A47),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Berhasil!",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Tiket $ticketType untuk ${event.nameEvent} berhasil dipesan!",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Return to previous screen
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// Separate Widget for Ticket Bottom Sheet
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

// Fungsi untuk format Rupiah Indonesia
String formatRupiah(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

// Separate Widget for Ticket Option
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
                "${formatRupiah(ticket.harga)}",
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
