import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game_item.dart';
import 'add_game_screen.dart';
import 'view_game_screen.dart';

class AllGamesScreen extends StatefulWidget {
  const AllGamesScreen({super.key});

  @override
  State<AllGamesScreen> createState() => _AllGamesScreenState();
}

class _AllGamesScreenState extends State<AllGamesScreen> {
  final List<GameItem> games = GameItem.gameList;
  List<GameItem> filteredGames = GameItem.gameList;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredGames = games;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchGames() {
    final query = searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredGames = games;
      } else {
        filteredGames = games.where((game) {
          // Search by game title
          final titleMatch = game.gameTitle.toLowerCase().contains(query);

          // Search by date
          final dateMatch = game.schedules.any((schedule) {
            final dateStr = DateFormat(
              'MMM dd, yyyy',
            ).format(schedule.startTime).toLowerCase();
            return dateStr.contains(query);
          });

          return titleMatch || dateMatch;
        }).toList();
      }
    });
  }

  void deleteGame(GameItem game) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Game'),
          content: Text(
            'Are you sure you want to delete "${game.gameTitle}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  games.remove(game);
                  searchGames(); // Refresh the filtered list
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${game.gameTitle} has been deleted'),
                    duration: const Duration(seconds: 2),
                  ),
                );

                Navigator.pop(context); // Close dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void viewGame(GameItem game) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewGameScreen(
          game: game,
          onGameDeleted: deleteGame,
        ),
      ),
    );
    setState(() {
      searchGames(); // Refresh the filtered list
    });
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
              'All Games',
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
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddGameScreen(),
                ),
              );
              setState(() {
                filteredGames = games; // Reset to show all games
                searchController.clear(); // Clear search field
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) => searchGames(),
              decoration: InputDecoration(
                hintText: 'Search by game name or date...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
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

          // Games List
          Expanded(
            child: filteredGames.isEmpty
                ? Center(
                    child: Text(
                      searchController.text.isEmpty
                          ? 'No games scheduled yet.\nTap + to add a new game.'
                          : 'No games found matching "${searchController.text}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];
                      final totalCost = game.getTotalCost();
                      final firstSchedule = game.schedules.first;

                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          // Show confirmation dialog
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Game'),
                                content: Text(
                                  'Are you sure you want to delete "${game.gameTitle}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          setState(() {
                            games.remove(game);
                            filteredGames.remove(game);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${game.gameTitle} has been deleted',
                              ),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  setState(() {
                                    games.add(game);
                                    searchGames();
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 32,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => viewGame(game),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Game Title
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          game.gameTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Schedule Info
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(firstSchedule.startTime),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${DateFormat('hh:mm a').format(firstSchedule.startTime)} - ${DateFormat('hh:mm a').format(firstSchedule.endTime)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (game.schedules.length > 1) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      '+${game.schedules.length - 1} more schedule${game.schedules.length - 1 > 1 ? 's' : ''}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[700],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 12),
                                  const Divider(),
                                  const SizedBox(height: 8),

                                  // Players and Cost
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Number of Players
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.people,
                                            size: 20,
                                            color: Colors.blue[700],
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${game.numberOfPlayers} player${game.numberOfPlayers != 1 ? 's' : ''}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Total Cost
                                      Text(
                                        '₱${totalCost.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddGameScreen(),
            ),
          );
          setState(() {
            filteredGames = games;
            searchController.clear();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New Game'),
        backgroundColor: Colors.purple[50],
      ),
    );
  }
}
