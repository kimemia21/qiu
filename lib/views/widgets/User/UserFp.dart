import 'dart:async';
import 'package:application/Models/FpDriverTracker.dart';
import 'package:application/views/widgets/WSP/homepage/wspglobals.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserFpDrivers extends StatefulWidget {
  const UserFpDrivers({super.key});

  @override
  State<UserFpDrivers> createState() => _UserFpDriversState();
}

class _UserFpDriversState extends State<UserFpDrivers> {
  late IO.Socket socket;
  bool empty = true;
  late Future<List<FpDriverTracker>> future;

  Future<List<FpDriverTracker>> _connectSocket() {
    final completer = Completer<List<FpDriverTracker>>();

    socket = IO.io(
      'ws://185.141.63.56:8080',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect() // Enable auto-reconnect
          .enableReconnection() // Enable reconnection
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .build(),
    );

    socket.connect();

    socket.onError((error) {
      print('Socket error: $error');
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit("get available drivers");
    });

    socket.on('available drivers', (data) {
      if (!mounted) return;
      // Check if the widget is still mounted
      try {
        if (data is List && data.isNotEmpty) {
          setState(() {
            empty = false;
          });
          final fpDrivers = data
              .map((driverData) => FpDriverTracker.fromJson(driverData))
              .toList();
          print(data);
          if (!completer.isCompleted) {
            completer.complete(fpDrivers);
          }
        } else {
          setState(() {
            empty = true;
          });
          if (!completer.isCompleted) {
            completer.completeError(Exception("No available drivers"));
          }
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    });

    socket.onDisconnect((_) => print('Disconnected from server'));

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    future = _connectSocket();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose(); // Ensure all resources are cleaned up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appGradient[0],
        centerTitle: true,
        title: Text(
          'Available Drivers',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorState(
                  context: context,
                  error: snapshot.error.toString(),
                  function: () => _connectSocket),
            );
          } else {
            List<FpDriverTracker> fpDrivers = snapshot.data!;
            return ListView.builder(
              itemCount: fpDrivers.length,
              itemBuilder: (context, index) {
                final driver = fpDrivers[index];
                return ListTile(
                  title: Text(driver.driver),
                  subtitle: Text(driver.fulfillmentPartner),
                );
              },
            );
          }
        },
      ),
    );
  }
}
