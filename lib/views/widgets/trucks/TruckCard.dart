import '../../../Models/TrucksModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TruckCard extends StatelessWidget {
  final Trucksmodel model;

  const TruckCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                border: Border(
                  left: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: 4,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.grey.withOpacity(0.7),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Truck Details',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    icon: Icons.numbers_rounded,
                    label: 'Truck ID',
                    value: model.id.toString(),
                    iconColor: Colors.grey.withOpacity(0.7),
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow(
                    icon: Icons.inventory_2_rounded,
                    label: 'Capacity',
                    value: "${model.capacity} Liters",
                    iconColor: Colors.grey.withOpacity(0.7),
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow(
                    icon: Icons.star_rounded,
                    label: 'Quality',
                    value:
                        "${model.quality == "1" ? "SoftWater" : "HardWater"}",
                    iconColor: Colors.grey.withOpacity(0.7),
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow(
                    icon: Icons.assignment_rounded,
                    label: 'Registration',
                    value: model.licence_plate,
                    iconColor: Colors.grey.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            // Footer with actions
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.withOpacity(0.05),
            //     border: Border(
            //       top: BorderSide(
            //         color: Colors.grey.withOpacity(0.1),
            //       ),
            //     ),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       _buildActionButton(
            //         icon: Icons.edit_rounded,
            //         label: 'Edit',
            //         onTap: () {},
            //         color: Colors.grey.withOpacity(0.7),
            //       ),
            //       SizedBox(width: 12),
            //       _buildActionButton(
            //         icon: Icons.delete_outline_rounded,
            //         label: 'Delete',
            //         isDestructive: true,
            //         onTap: () {},
            //         color: Colors.red.withOpacity(0.7),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
