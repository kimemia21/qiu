import 'package:application/views/widgets/WSP/homepage/wspglobals.dart';

import '../../../../Models/DriverModel.dart';
import 'DriverCard.dart';
import '../../globals.dart';
import '../../../../comms/Req.dart';
import 'package:flutter/material.dart';

class Drivers extends StatefulWidget {
  const Drivers({super.key});

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  late Future<List<Drivermodel>> _driversFuture;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _driversFuture =
        AppRequest.fetchDrivers(isProfile: false).catchError((error) {
      throw Exception('Failed to load drivers: $error');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshDrivers() async {
    setState(() {
      _initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF9FA8DA),
            Color(0xFF7E57C2),
          ],
          stops: [0.2, 0.8],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: RefreshIndicator(
            onRefresh: _refreshDrivers,
            color: const Color(0xFF7E57C2),
            child: _buildDriversList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDriversList() {
    return FutureBuilder<List<Drivermodel>>(
      future: _driversFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return Center(
            child: ErrorState(
                context: context,
                error: snapshot.error.toString(),
                function: () {}),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: EmptyState(type: "Drivers"),
          );
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Drivers',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7E57C2),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage and monitor your driver team',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final driver = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DriverCard(model: driver),
                  );
                },
                childCount: snapshot.data!.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80), // Space for the add button
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7E57C2)),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading drivers...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B7AFF), Color(0xFF7E57C2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B7AFF).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container();
                  });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Add New Driver',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
