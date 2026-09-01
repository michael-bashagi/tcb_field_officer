import 'package:flutter/material.dart';
import '../../../../farmer_registration/domain/farmer_request.dart';

class FarmerDetailPopup extends StatelessWidget {
  final FarmerRequest farmer;

  const FarmerDetailPopup({
    super.key,
    required this.farmer,
  });

  static Future<void> show(BuildContext context, FarmerRequest farmer) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FarmerDetailPopup(farmer: farmer),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2C5F2D);
    const accentBg = Color(0xFFE7EFE3);
    const darkTextColor = Color(0xFF303D2D);
    const goldAccent = Color(0xFFBE822C);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: darkTextColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: accentBg,
                child: Icon(Icons.person, color: primaryColor, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmer.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      farmer.phoneNumber,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    Icons.location_on_outlined,
                    'Farm Location (Geospatial)',
                    farmer.farm.locationFromGeospatial,
                    primaryColor,
                  ),
                  _buildDetailRow(
                    Icons.square_foot_outlined,
                    'Farm Size',
                    '${farmer.farm.sizeInAcres.toStringAsFixed(2)} Acres',
                    primaryColor,
                  ),
                  _buildDetailRow(
                    Icons.badge_outlined,
                    'Registered By (Officer)',
                    farmer.registeredByFieldOfficer.isNotEmpty
                        ? farmer.registeredByFieldOfficer
                        : 'N/A',
                    primaryColor,
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Billing Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    Icons.confirmation_number_outlined,
                    'Control Number',
                    farmer.controlNumber ?? 'Not Generated',
                    goldAccent,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Payment Status: ',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: farmer.paymentStatus == 'PAID'
                              ? Colors.green.shade50
                              : const Color(0xFFF9E7CA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: farmer.paymentStatus == 'PAID'
                                ? Colors.green
                                : goldAccent,
                          ),
                        ),
                        child: Text(
                          farmer.paymentStatus,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: farmer.paymentStatus == 'PAID'
                                ? Colors.green.shade800
                                : goldAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF303D2D),
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
