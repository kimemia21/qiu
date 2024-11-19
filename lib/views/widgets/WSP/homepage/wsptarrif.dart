import 'dart:convert';

import 'package:application/Models/user.dart';
import 'package:application/comms/comms_repo.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/views/state/appbloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:application/Models/Tarrifs.dart';

class WspTarrifs extends StatefulWidget {
  final List<TarrifsModel> tarrifsModel;

  const WspTarrifs({super.key, required this.tarrifsModel});

  @override
  State<WspTarrifs> createState() => _WspTarrifsState();
}

class _WspTarrifsState extends State<WspTarrifs> {
  final TextEditingController capacity = TextEditingController();
  final TextEditingController price = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Helper function to safely format numbers
  String formatNumber(dynamic value) {
    if (value == null) return '0';
    try {
      // Convert to double first to handle both int and double
      final number = double.parse(value.toString());
      return NumberFormat('#,###').format(number);
    } catch (e) {
      return value.toString(); // Return original value if parsing fails
    }
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      TarrifsModel tarrif, String value, String text, IconData icon,
      {bool isDestructive = false}) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red[400] : Colors.grey[700],
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isDestructive ? Colors.red[400] : Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF7E57C2).withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping_rounded,
                      color: Color(0xFF7E57C2),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "WSP Tariffs",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF7E57C2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Total: ${widget.tarrifsModel.length}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7E57C2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List Section
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thickness: 8,
              radius: Radius.circular(4),
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: widget.tarrifsModel.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tarrif = widget.tarrifsModel[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF7E57C2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.fire_truck_outlined,
                          color: Color(0xFF7E57C2),
                          size: 24,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF7E57C2).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.water_drop_outlined,
                                    size: 16,
                                    color: Color(0xFF7E57C2),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${formatNumber(tarrif.truckCapacity)} liters",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.attach_money,
                                  size: 16,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Ksh ${formatNumber(tarrif.capacityPrice)}",
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        onSelected: (String value) {
                          if (value == 'Edit') {
                 

                            showWSPModals(
                              context: context,
                              capcityController: capacity,
                              priceController: price,
                              model: tarrif,
                              isCreate: value != 'Edit',
                            );
                          } else if (value == 'Delete') {
                            DeleteAlertDialog.show(
                                context: context, model: tarrif);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          _buildPopupMenuItem(
                            tarrif,
                            'Edit',
                            'Edit',
                            Icons.edit,
                          ),
                          _buildPopupMenuItem(
                            tarrif,
                            'Delete',
                            'Delete',
                            Icons.delete,
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteAlertDialog {
  static Future<bool?> show({
    required BuildContext context,
    required TarrifsModel model,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Confirmation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this item?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Item Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildDetailRow('Capacity', model.truckCapacity),
                    const SizedBox(height: 8),
                    _buildDetailRow('Name', model.Id.toString()),
                    const SizedBox(height: 8),
                    _buildDetailRow('Price', model.capacityPrice),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                comms_repo.QueryAPIDelete(
                        "${base_url}wsp/tariff/:${model.Id}", context)
                    .then((value) {
                  if (value["success"] == true) {
                    CustomSnackBar.show(
                      context: context,
                      message: "Item deleted successfully",
                      type: SnackBarType.success,
                    );

                    Navigator.of(context).pop(true);
                  } else {
                    CustomSnackBar.show(
                      context: context,
                      message: "delete error ${value["message"]}",
                      type: SnackBarType.error,
                    );

                    Navigator.of(context).pop(true);
                  }
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.delete_outline, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
