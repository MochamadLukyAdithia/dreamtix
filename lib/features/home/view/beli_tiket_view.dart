import 'package:dreamtix/features/home/model/tiket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:intl/intl.dart';

class BeliTiketScreen extends StatefulWidget {
  final Tiket? ticket;
  const BeliTiketScreen({super.key, required this.ticket});

  @override
  State createState() => _BeliTiketScreenState();
}

class _BeliTiketScreenState extends State<BeliTiketScreen> {
  int quantity = 1;
  String? selectedMethod;

  List<String> metodePembayaran = [
    'Qris',
  ];

  // Fungsi untuk format Rupiah Indonesia
  String formatRupiah(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final harga = widget.ticket?.harga ?? 0;
    final total = harga * quantity;

    return Scaffold(
      backgroundColor: Color(0xFF0F1419), // Darker navy background to match
      appBar: AppBar(
        title: Text(
          "Pembelian Tiket",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF0F1419), // Match background
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.toNamed("detail-event"),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1419), // Dark navy
              Color(0xFF1A1F2E), // Slightly lighter navy
              Color(0xFF252B3A), // Even lighter for depth
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Informasi Tiket - matching the screenshot cards
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF252B3A), // Solid color matching screenshot
                  borderRadius:
                      BorderRadius.circular(16), // Slightly smaller radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                Colors.red, // Red accent color from screenshot
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.confirmation_number,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.ticket?.category.nama ?? 'Tiket',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1F2E).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Harga: ${formatRupiah(harga)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Quantity Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF252B3A), // Match card color
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xFF353B4A).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jumlah Tiket",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: quantity > 1
                                ? Colors.red // Match red accent
                                : Color(0xFF353B4A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: quantity > 1
                                ? () => setState(() => quantity--)
                                : null,
                            icon: Icon(Icons.remove),
                            color: Colors.white,
                            iconSize: 24,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF1A1F2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFF353B4A)),
                          ),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF4ECDC4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => setState(() => quantity++),
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            iconSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Total Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF252B3A), // Solid background
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xFFFF5A5F).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Bayar:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      formatRupiah(total),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4ECDC4),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Metode Pembayaran
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF252B3A), // Match card color
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xFF353B4A).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Metode Pembayaran",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF353B4A)),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedMethod,
                        underline: SizedBox(),
                        dropdownColor: Color(0xFF252B3A),
                        style: TextStyle(color: Colors.white),
                        hint: Text(
                          "Pilih metode pembayaran",
                          style: TextStyle(color: Colors.white70),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.white70),
                        items: metodePembayaran.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(
                              method,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMethod = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Tombol Konfirmasi - matching the red button from screenshot
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: selectedMethod == null
                      ? LinearGradient(
                          colors: [Color(0xFF353B4A), Color(0xFF353B4A)])
                      : LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.red
                          ], // Match screenshot red
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: selectedMethod == null
                      ? []
                      : [
                          BoxShadow(color: Colors.red),
                        ],
                ),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.payment,
                    color: Colors.white,
                  ),
                  onPressed: selectedMethod == null
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Tiket dibeli: $quantity, Total: ${formatRupiah(total)}, Metode: $selectedMethod",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Color(0xFF4ECDC4),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                  label: Text(
                    "Konfirmasi Pembayaran",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
