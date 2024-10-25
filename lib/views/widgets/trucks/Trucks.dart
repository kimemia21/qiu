
import 'package:application/views/widgets/Models/TrucksModel.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:application/views/widgets/request/Req.dart';
import 'package:flutter/material.dart';

class Trucks extends StatefulWidget {
  const Trucks({super.key});

  @override
  State<Trucks> createState() => _TrucksState();
}

class _TrucksState extends State<Trucks> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
      
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF9FA8DA),
                  Color(0xFF7E57C2),
                ],
              ),
            ),
          ),

          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<List<trucksmodel>>(
                      future: AppRequest.fetchTrucks(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<trucksmodel>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No Trucks Available'));
                        }

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(), // Prevents scrolling
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final trucks = snapshot.data![index];
                            return TruckCard(model: trucks,);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12), 
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B7AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Truck',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class TruckCard extends StatelessWidget {
  final trucksmodel model;

  const TruckCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Truck ID
          _buildInfoRow(Icons.card_travel, 'Truck ID: ${model.id}'),

          // Capacity
          _buildInfoRow(Icons.emoji_transportation, 'Capacity: ${model.capacity}'),

          // Quality
          _buildInfoRow(Icons.star, 'Quality: ${model.quality}'),

          // Registration
          _buildInfoRow(Icons.assignment, 'Registration: ${model.reg}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
