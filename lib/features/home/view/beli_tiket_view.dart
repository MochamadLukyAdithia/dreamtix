import 'package:dreamtix/features/home/model/tiket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BeliTiketScreen extends StatefulWidget {
  final Tiket? ticket;
  const BeliTiketScreen({super.key, required this.ticket});

  @override
  State<BeliTiketScreen> createState() => _BeliTiketScreenState();
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
      backgroundColor: Color(0xFF0D0C2D),
      appBar: AppBar(
        title: Text(
          "Pembelian Tiket",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF0D0C2D),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0C2D),
              Color(0xFF1B1A47),
              Color(0xFF252B3A),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Informasi Tiket
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1B1A47),
                  borderRadius: BorderRadius.circular(16),
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
                            color: Colors.red,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.ticket?.category.nama ?? 'Tiket',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.ticket?.category.posisi ?? 'Posisi',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFF0D0C2D).withOpacity(0.8),
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
                  color: Color(0xFF1B1A47),
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
                            color:
                                quantity > 1 ? Colors.red : Color(0xFF353B4A),
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
                            color: Color(0xFF0D0C2D),
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
                            color: Colors.red,
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
                  color: Color(0xFF1B1A47),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
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
                        color: Colors.red,
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
                  color: Color(0xFF1B1A47),
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
                        color: Color(0xFF0D0C2D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF353B4A)),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedMethod,
                        underline: SizedBox(),
                        dropdownColor: Color(0xFF1B1A47),
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
// Tombol Konfirmasi
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.payment,
                    color: Colors.white,
                  ),
                  onPressed: selectedMethod == null
                      ? null
                      : () {
                          // Tampilkan alert konfirmasi
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Konfirmasi Pesanan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Pastikan pesanan Anda sudah benar:"),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Tiket:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                            "${widget.ticket!.category.nama ?? 'N/A'}"),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Jumlah:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text("$quantity tiket"),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Metode Bayar:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text("$selectedMethod"),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "Rp ${total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Tutup dialog
                                    },
                                    child: Text(
                                      "Batal",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Tutup dialog

                                      // Create payment data object
                                      // final paymentData = {
                                      //   'ticket': widget.ticket,
                                      //   'quantity': quantity,
                                      //   'total': total,
                                      //   'paymentMethod': selectedMethod,
                                      // };

                                      // Navigate to payment screen with data
                                      Get.toNamed("bayar-tiket",
                                          arguments: total);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text("Lanjut Bayar"),
                                  ),
                                ],
                              );
                            },
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
                    backgroundColor:
                        selectedMethod == null ? Color(0xFF353B4A) : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: selectedMethod == null ? 0 : 4,
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
