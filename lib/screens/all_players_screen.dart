import 'package:flutter/material.dart';
import '../widgets/players_list.dart';
import 'add_player_screen.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPlayerScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: PlayersList(),
    );
  }
}
