import 'package:application/Models/TrucksModel.dart';
import 'package:application/comms/Req.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/utils/utils.dart';
import 'package:application/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> CreateNewDriver(BuildContext context) async {
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
          child: const CreateDriverkWidget()));
}

class CreateDriverkWidget extends StatefulWidget {
  const CreateDriverkWidget({super.key});
  @override
  _CreateDriverkWidgetState createState() => _CreateDriverkWidgetState();
}

class _CreateDriverkWidgetState extends State<CreateDriverkWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  late Future<List<Trucksmodel>> trucks;
  Trucksmodel? selectedTruck; 
  String? truckId;

  // final TextEditingController _priceController = TextEditingController();
  bool savingDriver = false;

  String _selectedQuality = 'Soft Water';

  @override
  void initState() {
    super.initState();
    trucks = getTrucks();
  }

  Future<List<Trucksmodel>> getTrucks() async {
    return await AppRequest.fetchTrucks();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        savingDriver = false;
      });
      final Map<String, dynamic> driverData = {
        'firstName': _firstNameController.text.replaceAll(",", ""),
        'phoneNo': _phoneNumber.text.replaceAll(",", ""),
        'lastName': _lastNameController.text.trim().replaceAll(" ", ""),
        'truckId': truckId,
        "fp_id": current_user.id,
      };


      print('Truck Data: $driverData');

      await comms_repo.QueryAPIpost("fp/add-driver", driverData, context)
          .then((value) {
        printLog("Save driver  info $value");

        setState(() {
          savingDriver = false;
        });

        if (value["success"] ?? false) {
          showalert(
              true, context, "Success", value["message"] ?? "driver Saved");
        } else {
          showalert(false, context, "Failed",
              value["message"] ?? "Unable to Save driver");
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
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First name ',
                      hintText: 'Enter  driver first name',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the First  name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last name ',
                      hintText: 'Enter  driver\'s last name',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneNumber,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter Driver\'s phone number',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the driver\s phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedQuality,
                    decoration: InputDecoration(
                      labelText: 'Water Type',
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
                  FutureBuilder<List<Trucksmodel>>(
                    future: trucks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No trucks available');
                      }

                      return DropdownButtonFormField<Trucksmodel>(
                        value: selectedTruck,
                        decoration: InputDecoration(
                          labelText: 'Trucks',
                        ),
                        items: snapshot.data!.map((truck) {
                          return DropdownMenuItem<Trucksmodel>(
                            value: truck,
                            child: Text(truck.licence_plate
                                .toString()), 
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTruck = value;
                            truckId = value!.id.toString();
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 32),
                  savingDriver
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
                                'Add Driver',
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
