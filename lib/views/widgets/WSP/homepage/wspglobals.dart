import 'package:flutter/material.dart';

Widget EmptyState({required String type}) {
  return Container(
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.info_outline,
            color: Colors.blue[400],
            size: 32,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'No $type Available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'There are currently no $type to display.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget ErrorState(
    {required BuildContext context,
    required String error,
    required Function function}) {
  return Container(
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.error_outline,
            color: Colors.red[400],
            size: 32,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Oops! Something went wrong',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Error: $error',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: ()=>function,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade400,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.refresh,
                size: 18,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text('Retry'),
            ],
          ),
        ),
      ],
    ),
  );
}
