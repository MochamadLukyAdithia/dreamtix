import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:dreamtix/features/home/model/tiket_model.dart';
import 'package:dreamtix/features/home/controller/HomeController.dart';
import 'package:dreamtix/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailEventController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final EventModel event;
  late TabController tabController;

  // Observable properties
  final RxList<Tiket> tickets = <Tiket>[].obs;
  final RxBool isLoadingTickets = false.obs;
  final RxInt selectedTab = 0.obs;

  // Get HomeController instance
  final HomeController homeController = Get.find<HomeController>();

  // Constructor to accept event
  DetailEventController({EventModel? eventData}) {
    if (eventData != null) {
      event = eventData;
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Initialize event from arguments if not provided in constructor
    if (!_isEventInitialized()) {
      final args = Get.arguments;
      if (args is EventModel) {
        event = args;
      } else {
        // Handle error case
        Get.snackbar(
          'Error',
          'Event data not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back();
        return;
      }
    }

    // Initialize tab controller
    tabController = TabController(length: 1, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });

    // Load tickets for this event
    loadTickets();
  }

  bool _isEventInitialized() {
    try {
      // Try to access event properties to check if initialized
      event.idEvent;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // Load tickets for the current event
  Future<void> loadTickets() async {
    try {
      isLoadingTickets.value = true;
      print('Loading tickets for event ID: ${event.idEvent}');

      // Call HomeController method to get tickets by event ID
      final result = await homeController.getTiketsByEventId(event.idEvent);

      tickets.assignAll(result);
      print('Loaded ${result.length} tickets');
    } catch (e) {
      print('Error loading tickets: $e');
      Get.snackbar(
        'Error',
        'Failed to load tickets: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingTickets.value = false;
    }
  }

  // Refresh tickets
  Future<void> refreshTickets() async {
    await loadTickets();
  }

  // Select a ticket and navigate to purchase screen
  void selectTicket(Tiket ticket) {
    Get.back(); // Close bottom sheet first
    Get.toNamed(AppRoute.beliTiket, arguments: ticket);
  }

  // Show ticket selection bottom sheet
  void showTicketBottomSheet() async {
    if (tickets.isEmpty && !isLoadingTickets.value) {
      await loadTickets();
    }

    Get.bottomSheet(
      TicketBottomSheet(),
      backgroundColor: const Color(0xFF1B1A47),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }

  // Show success dialog after ticket purchase
  void showSuccessDialog(String ticketType) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1B1A47),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          "Success!",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Ticket $ticketType for ${event.nameEvent} has been successfully ordered!",
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Return to previous screen
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void goBack() {
    Get.back();
  }

  void goToHome() {
    Get.offAllNamed(AppRoute.home);
  }

  // Get event details
  EventModel get eventDetails => event;

  // Check if tickets are available
  bool get hasTickets => tickets.isNotEmpty;

  // Get tickets count
  int get ticketsCount => tickets.length;
}

// Ticket Bottom Sheet Widget
class TicketBottomSheet extends GetView<DetailEventController> {
  const TicketBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              "Select Ticket Type",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Tickets list
            Obx(() {
              if (controller.isLoadingTickets.value) {
                return Container(
                  height: 100,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
                );
              }

              if (controller.tickets.isEmpty) {
                return Container(
                  height: 100,
                  child: const Center(
                    child: Text(
                      "No tickets available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
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

            const SizedBox(height: 20),

            // Refresh button
            TextButton(
              onPressed: () => controller.refreshTickets(),
              child: const Text(
                "Refresh Tickets",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ticket Option Widget
class TicketOption extends StatelessWidget {
  final Tiket ticket;

  const TicketOption({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailEventController>();

    return GestureDetector(
      onTap: () => controller.selectTicket(ticket),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2958),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.category.nama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Harga: Rp ${ticket.harga}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Posisi: ${ticket.category.posisi ?? "Tidak ditentukan"}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tersisa: ${ticket.stok ?? "Tidak ditentukan"}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Beli",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
