import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailEventScreen extends StatefulWidget {
  final EventModel event;

  DetailEventScreen({required this.event});

  @override
  State<DetailEventScreen> createState() => _DetailEventScreenState();
}

class _DetailEventScreenState extends State<DetailEventScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0C2D),
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
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
                    widget.event.image,
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
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    widget.event.name_event,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Event Info Cards
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: "Tanggal & Waktu",
                    content: _formatDateTime(widget.event.waktu),
                  ),
                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.person,
                    title: "Artis",
                    content: widget.event.artis,
                  ),
                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: "Lokasi",
                    content: "Seven Dream City, Jember",
                  ),
                  SizedBox(height: 24),

                  // Map Section
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[800],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          // You can replace this with actual map widget
                          Container(
                            color: Colors.grey[700],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.map, size: 48, color: Colors.grey[500]),
                                  SizedBox(height: 8),
                                  Text(
                                    "Map View",
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Map overlay with location info
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Seven Dream City, Jember",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Tab Section
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(0xFF1B1A47),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Deskripsi"),
                        Tab(text: "Line Up"),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Tab Content
                  Container(
                    height: 200,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDescriptionTab(),
                        _buildLineUpTab(),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String content}) {
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

  Widget _buildDescriptionTab() {
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
            "Nikmati pengalaman musik yang tak terlupakan dengan ${widget.event.artis} di ${widget.event.name_event}. Event ini akan menghadirkan pertunjukan spektakuler dengan sound system berkualitas tinggi dan lighting yang memukau.\n\nBergabunglah dengan ribuan penggemar musik untuk merasakan atmosfer yang luar biasa di Seven Dream City, Jember. Jangan lewatkan kesempatan emas ini!",
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
          ..._buildFacilityList(),
        ],
      ),
    );
  }

  List<Widget> _buildFacilityList() {
    final facilities = [
      "Parking area yang luas",
      "Food court dan minuman",
      "Security 24 jam",
      "Toilet bersih",
      "Area merchandise",
    ];

    return facilities.map((facility) => Padding(
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
    )).toList();
  }

  Widget _buildLineUpTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lineup Artis",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          _buildArtistCard(widget.event.artis, "Main Artist", true),
          SizedBox(height: 8),
          _buildArtistCard("Opening Act 1", "Supporting Artist", false),
          SizedBox(height: 8),
          _buildArtistCard("Opening Act 2", "Supporting Artist", false),
          SizedBox(height: 16),
          Text(
            "Rundown Acara:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          ..._buildRundownList(),
        ],
      ),
    );
  }

  Widget _buildArtistCard(String name, String type, bool isMain) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1B1A47),
        borderRadius: BorderRadius.circular(8),
        border: isMain ? Border.all(color: Colors.red, width: 1) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isMain ? Colors.red : Colors.grey[600],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isMain)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "HEADLINER",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRundownList() {
    final rundown = [
      {"time": "19:00", "activity": "Gates Open"},
      {"time": "20:00", "activity": "Opening Act 1"},
      {"time": "21:00", "activity": "Opening Act 2"},
      {"time": "22:00", "activity": "${widget.event.artis} Performance"},
      {"time": "24:00", "activity": "Event End"},
    ];

    return rundown.map((item) => Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(
              item["time"]!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              item["activity"]!,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildBottomButton() {
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
            _showTicketBottomSheet();
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

  void _showTicketBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1B1A47),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
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
              _buildTicketOption("Regular", "Rp 150.000", "Standing area"),
              SizedBox(height: 12),
              _buildTicketOption("VIP", "Rp 300.000", "VIP seating area"),
              SizedBox(height: 12),
              _buildTicketOption("VVIP", "Rp 500.000", "Front row + meet & greet"),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTicketOption(String type, String price, String description) {
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
                  type,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
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
                price,
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
                onPressed: () {
                  Get.back();
                  _showSuccessDialog(type);
                },
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

  void _showSuccessDialog(String ticketType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B1A47),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "Berhasil!",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Tiket $ticketType untuk ${widget.event.name_event} berhasil dipesan!",
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back(); // Return to home
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy • HH:mm', 'id_ID').format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }
}