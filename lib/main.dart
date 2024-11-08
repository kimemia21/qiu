import 'package:application/views/signinUpPage.dart';
import 'package:application/views/signinpage.dart';
import 'package:application/views/state/appbloc.dart';
import 'package:application/views/widgets/WSP/WSP.dart';
import 'package:application/views/widgets/WSP/wsp_orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // .kimemia run using fvm
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Appbloc())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: WspOrdersScreen(),
      ),
    );
  }
}

class DynamicInputScreen extends StatefulWidget {
  @override
  _DynamicInputScreenState createState() => _DynamicInputScreenState();
}

class _DynamicInputScreenState extends State<DynamicInputScreen> {
  int _trucksCount = 0;
  List<Map<String, dynamic>> _truckData = [];

  void _updateTrucksCount(int count) {
    setState(() {
      _trucksCount = count;
      _truckData = List.generate(
          count,
          (_) => {
                'capacity': '',
                'quality': 1, // Default value
                'licencePlate': '',
                'price': '',
              });
    });
  }

  void _updateTruckData(int index, String field, dynamic value) {
    setState(() {
      _truckData[index][field] = value;
    });
  }

  void _deleteTruck(int index) {
    setState(() {
      _truckData.removeAt(index);
      _trucksCount = _truckData.length;
    });
  }

  bool _validateFields() {
    for (var truck in _truckData) {
      if (truck['capacity'].isEmpty ||
          truck['licencePlate'].isEmpty ||
          truck["quality"].isEmpty||
          truck['price'].isEmpty) {
        return false;
      }
    }
    return true;
  }

  void _submitData() {
    if (_validateFields()) {
      Map<String, dynamic> data = {
        'trucksCount': _trucksCount,
        'trucks': _truckData,
      };
      print(data); // Replace with your API call
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7E64D4),
              Color(0xFF9DD6F8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              SvgPicture.asset(
                'assets/images/Logo.svg',
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Manage Your Fleet',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (int.parse(value) > 10) {
                    AlertDialog(
                      title: Text("invalid number of trucks"),
                    );
                  }
                  int count = int.tryParse(value) ?? 0;
                  _updateTrucksCount(count);
                },
                decoration: InputDecoration(
                  hintText: 'Enter the number of trucks',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _truckData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  _updateTruckData(index, 'capacity', value),
                              decoration: InputDecoration(
                                hintText: 'Capacity',
                                
                                label: Text("Capacity"),
                                border: OutlineInputBorder(),
                                errorText: _truckData[index]['capacity'].isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<int>(
                              value: _truckData[index]['quality'],
                              onChanged: (value) =>
                                  _updateTruckData(index, 'quality', value),
                              items: const [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Soft Water'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Hard Water'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              
                              onChanged: (value) => _updateTruckData(
                                  index, 'licencePlate', value),
                              decoration: InputDecoration(
                                label: Text("License Plate"),
                                hintText: 'License Plate',
                                border: OutlineInputBorder(),
                                errorText:
                                    _truckData[index]['licencePlate'].isEmpty
                                        ? 'Required'
                                        : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  _updateTruckData(index, 'price', value),
                              decoration: InputDecoration(
                                
                                label: Text("Price"),
                                hintText: 'Price',
                                border: OutlineInputBorder(),
                                errorText: _truckData[index]['price'].isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteTruck(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text('Submit', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
