import 'package:application/views/widgets/Fps/homepage/infocard.dart';
import 'package:application/views/widgets/Maps/MapScreen.dart';
import 'package:application/views/widgets/Orders/CreatOrder.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Userhomepage extends StatefulWidget {
  const Userhomepage({super.key});

  @override
  State<Userhomepage> createState() => _UserhomepageState();
}

class _UserhomepageState extends State<Userhomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appGradient[0],
        centerTitle: true,
        title: Text(
          "User HomePage",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: appGradient),
        ),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InfoCard(
                        title: "Create Order",
                        icon: Icons.add_shopping_cart,
                        color: Colors.blue,
                        tapped: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateOrderScreen()
                        
                                  //  MapScreen()
                                  ));
                        }),
                        
                    
                    SizedBox(height: 16), 
                       InfoCard(
                        title: "View Orders",
                        icon: Icons.list,
                        color: Colors.black,
                        tapped: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateOrderScreen()
                        
                                  //  MapScreen()
                                  ));
                        }),
                    
               
                  
                    SizedBox(height: 16), // Add space between buttons
                           InfoCard(
                        title: "Account",
                        icon: Icons.account_circle,
                        color: Colors.black,
                        tapped: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateOrderScreen()
                        
                                  //  MapScreen()
                                  ));
                        }),
                   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom method to build consistent action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade400,
        minimumSize:
            Size(double.infinity, double.infinity), // Fill entire space
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, size: 48), // Increased icon size
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 20), // Increased text size
          ),
        ],
      ),
    );
  }
}
