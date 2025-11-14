import 'package:flutter/material.dart';
import '../models/player_item.dart';
import '../widgets/players_list.dart';
import 'add_player_screen.dart';
import 'edit_player_screen.dart';

class AllPlayersScreen extends StatefulWidget {
  const AllPlayersScreen({super.key});

  @override
  State<AllPlayersScreen> createState() => _AllPlayersScreenState();
}

class _AllPlayersScreenState extends State<AllPlayersScreen> {
  final List<PlayerItem> players = PlayerItem.playerList;
  List<PlayerItem> filteredPlayers = PlayerItem.playerList;
  final TextEditingController searchController = TextEditingController();

  /// Filters the players list based on the search query matching nickname or full name
  void searchPlayers() {
    final query = searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredPlayers = players;
      } else {
        filteredPlayers = players.where((player) {
          return player.nickname.toLowerCase().contains(query) ||
              player.fullName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  /// Deletes a player from the list and shows a confirmation message
  void deletePlayer(PlayerItem player) {
    setState(() {
      players.remove(player);
      searchPlayers(); // Refresh the filtered list
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player.nickname} has been deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Navigates to the edit player screen with the selected player
  void editPlayer(PlayerItem player) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlayerScreen(
          player: player,
          onPlayerUpdated: (updatedPlayer) {
            setState(() {
              searchPlayers(); // Refresh the filtered list
            });
          },
          onPlayerDeleted: deletePlayer,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    filteredPlayers = players;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              setState(() {
                filteredPlayers = players; // Reset to show all players
                searchController.clear(); // Clear search field
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) => searchPlayers(),
              decoration: InputDecoration(
                hintText: 'Search player...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 1.5,
                  ),
                ),
              ),
              enabled: true,
            ),
          ),
          Expanded(
            child: PlayersList(
              players: filteredPlayers,
              onPlayerDeleted: deletePlayer,
              onPlayerTapped: editPlayer,
            ),
          ),
        ],
      ),
    );
  }
}
