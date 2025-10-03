import 'package:flutter/material.dart';
import '../models/player_item.dart';
import '../widgets/players_list.dart';
import 'add_player_screen.dart';

class AllPlayersScreen extends StatefulWidget {
  const AllPlayersScreen({super.key});

  @override
  State<AllPlayersScreen> createState() => _AllPlayersScreenState();
}

class _AllPlayersScreenState extends State<AllPlayersScreen> {
  final List<PlayerItem> players = PlayerItem.playerList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
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
            onPressed: () async {
              await Navigator.push<PlayerItem>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPlayerScreen(),
                ),
              );
              setState(() {}); // Refresh the list
            },
          ),
        ],
      ),
      body: PlayersList(),
    );
  }
}
