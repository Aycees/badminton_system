import 'package:flutter/material.dart';

class AllPlayersScreen extends StatelessWidget {
  const AllPlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'All Players',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            padding: const EdgeInsets.all(10.0),
            onPressed: () {
              // Add your logic for the "+" button here
              print('Add button pressed');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('List of all players will be displayed here.'),
      ),
    );
  }
}
