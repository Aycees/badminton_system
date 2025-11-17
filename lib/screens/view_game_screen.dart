import 'package:flutter/material.dart';
import '../models/game_item.dart';
import 'select_players_screen.dart';
import '../widgets/game_title_section.dart';
import '../widgets/court_information_section.dart';
import '../widgets/schedules_section.dart';
import '../widgets/players_section.dart';
import '../widgets/cost_breakdown_section.dart';

class ViewGameScreen extends StatefulWidget {
  final GameItem game;
  final Function(GameItem) onGameDeleted;

  const ViewGameScreen({
    super.key,
    required this.game,
    required this.onGameDeleted,
  });

  @override
  State<ViewGameScreen> createState() => _ViewGameScreenState();
}

class _ViewGameScreenState extends State<ViewGameScreen> {
  late int numberOfPlayers;

  @override
  void initState() {
    super.initState();
    numberOfPlayers = widget.game.numberOfPlayers;
  }

  /// Updates the number of players for the game
  void updatePlayerCount(int count) {
    setState(() {
      numberOfPlayers = count;
      widget.game.numberOfPlayers = count;
    });
  }

  /// Updates shuttlecock cost assignment
  void updateShuttlecockAssignment(bool divideEqually, String? payerNickname) {
    setState(() {
      widget.game.divideShuttleCockEqually = divideEqually;
      widget.game.shuttleCockPayerNickname = payerNickname;

      // If assigned player is removed from game, reset to divide equally
      if (!divideEqually &&
          payerNickname != null &&
          !widget.game.selectedPlayerNicknames.contains(payerNickname)) {
        widget.game.divideShuttleCockEqually = true;
        widget.game.shuttleCockPayerNickname = null;
      }
    });
  }

  /// Updates court cost assignment
  void updateCourtAssignment(bool divideEqually, List<String> payerNicknames) {
    setState(() {
      widget.game.divideCourtEqually = divideEqually;
      widget.game.courtPayerNicknames = List<String>.from(payerNicknames);

      // If assigned players are removed from game, reset to divide equally
      if (!divideEqually && payerNicknames.isNotEmpty) {
        final validPayers = payerNicknames
            .where(
              (nickname) =>
                  widget.game.selectedPlayerNicknames.contains(nickname),
            )
            .toList();

        if (validPayers.isEmpty) {
          widget.game.divideCourtEqually = true;
          widget.game.courtPayerNicknames = [];
        } else {
          widget.game.courtPayerNicknames = List<String>.from(validPayers);
        }
      }
    });
  }

  /// Shows dialog to edit court information
  void editCourtInfo() {
    final courtNameController = TextEditingController(
      text: widget.game.courtName,
    );
    final courtRateController = TextEditingController(
      text: widget.game.courtRate.toString(),
    );
    final shuttleCockPriceController = TextEditingController(
      text: widget.game.shuttleCockPrice.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Court Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: courtNameController,
                  decoration: const InputDecoration(
                    labelText: 'Court Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: courtRateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Court Rate (per hour)',
                    border: OutlineInputBorder(),
                    prefixText: '₱ ',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: shuttleCockPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Shuttle Cock Price',
                    border: OutlineInputBorder(),
                    prefixText: '₱ ',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.game.courtName = courtNameController.text;
                  widget.game.courtRate =
                      double.tryParse(
                        courtRateController.text,
                      ) ??
                      widget.game.courtRate;
                  widget.game.shuttleCockPrice =
                      double.tryParse(
                        shuttleCockPriceController.text,
                      ) ??
                      widget.game.shuttleCockPrice;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /// Navigates to the select players screen to add or modify players for this game
  void navigateToSelectPlayers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectPlayersScreen(
          selectedPlayerNicknames: widget.game.selectedPlayerNicknames,
          onPlayersSelected: (selectedPlayers) {
            setState(() {
              widget.game.selectedPlayerNicknames = selectedPlayers;
              // Automatically update player count
              numberOfPlayers = selectedPlayers.length;
              widget.game.numberOfPlayers = selectedPlayers.length;

              // Reset shuttlecock assignment if assigned player was removed
              if (!widget.game.divideShuttleCockEqually &&
                  widget.game.shuttleCockPayerNickname != null &&
                  !selectedPlayers.contains(
                    widget.game.shuttleCockPayerNickname,
                  )) {
                widget.game.divideShuttleCockEqually = true;
                widget.game.shuttleCockPayerNickname = null;
              }

              // Reset court assignment if assigned players were removed
              if (!widget.game.divideCourtEqually &&
                  widget.game.courtPayerNicknames.isNotEmpty) {
                final validPayers = widget.game.courtPayerNicknames
                    .where(
                      (nickname) => selectedPlayers.contains(nickname),
                    )
                    .toList();

                if (validPayers.isEmpty) {
                  widget.game.divideCourtEqually = true;
                  widget.game.courtPayerNicknames = [];
                } else {
                  widget.game.courtPayerNicknames = validPayers;
                }
              }
            });
          },
        ),
      ),
    );
  }

  /// Shows a confirmation dialog and deletes the game if confirmed
  void deleteGame() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Game'),
          content: Text(
            'Are you sure you want to delete "${widget.game.gameTitle}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onGameDeleted(widget.game);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close view screen
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteGame,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GameTitleSection(gameTitle: widget.game.gameTitle),
            const SizedBox(height: 16),
            CourtInformationSection(
              game: widget.game,
              onCourtAssignmentChanged: updateCourtAssignment,
              onShuttlecockAssignmentChanged: updateShuttlecockAssignment,
              onEditCourtInfo: editCourtInfo,
            ),
            const SizedBox(height: 16),
            SchedulesSection(game: widget.game),
            const SizedBox(height: 16),
            PlayersSection(
              game: widget.game,
              onAddPlayers: navigateToSelectPlayers,
            ),
            const SizedBox(height: 16),
            CostBreakdownSection(
              game: widget.game,
              numberOfPlayers: numberOfPlayers,
            ),
          ],
        ),
      ),
    );
  }
}
