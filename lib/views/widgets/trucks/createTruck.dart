import 'package:application/comms/comms_repo.dart';
import 'package:application/views/state/appbloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../comms/credentials.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets.dart';

Future<dynamic> CreateNewTruck(BuildContext context) async {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isDismissible: true,
      showDragHandle: true,
      // enableDrag:,
      isScrollControlled: true,
      builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const CreateTruckWidget()));
}

class CreateTruckWidget extends StatefulWidget {
  const CreateTruckWidget({super.key});
  @override
  _CreateTruckWidgetState createState() => _CreateTruckWidgetState();
}

class _CreateTruckWidgetState extends State<CreateTruckWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool savingtruck = false;

  String _selectedQuality = 'Soft Water';

  @override
  void dispose() {
    _capacityController.dispose();
    _licensePlateController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        savingtruck = false;
      });
      // kime100 no enpoint for adding a driver on the fp page this data is for reg fp 
      final truckData = {
        'trucksCount': 1,
        "trucks": [
          {
            'capacity': _capacityController.text.replaceAll(",", ""),
            'quality': _selectedQuality,
            'licensePlate':
                _licensePlateController.text.trim().replaceAll(" ", ""),
            'price': _priceController.text.replaceAll(",", ""),
          }
        ]
      };

      print('Truck Data: $truckData');

      await comms_repo.QueryAPIpost("fp/register", truckData, context)
          .then((value) {
        printLog("Save truck  info $value");

        setState(() {
          savingtruck = false;
        });

        if (value["success"] ?? false) {
          showalert(
              true, context, "Success", value["message"] ?? "Truck Saved");
        } else {
          showalert(false, context, "Failed",
              value["message"] ?? "Unable to Save Truck");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.7,
        // widthFactor: 0.9,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _capacityController,
                    decoration: InputDecoration(
                      labelText: 'Capacity',
                      hintText: 'Enter truck capacity (e.g., 10000)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the capacity';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedQuality,
                    decoration: InputDecoration(
                      labelText: 'Water Quality',
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 'Soft Water', child: Text('Soft Water')),
                      DropdownMenuItem(
                          value: 'Hard Water', child: Text('Hard Water')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedQuality = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _licensePlateController,
                    decoration: InputDecoration(
                      labelText: 'License Plate',
                      hintText: 'Enter license plate (e.g., KBC1234)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the license plate';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      hintText: 'Enter price (e.g., 10000)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  context.watch<Appbloc>().isLoading
                      ? SpinKitThreeInOut(
                          color: Colors.blue,
                        )
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6B7AFF),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Add Truck',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        )));
  }
}
