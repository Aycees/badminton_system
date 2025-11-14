import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game_item.dart';
import '../models/player_item.dart';
import 'select_players_screen.dart';

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
    final totalCost = widget.game.getTotalCost();
    final totalHours = widget.game.getTotalHours();
    final costPerPlayer = numberOfPlayers > 0 ? totalCost / numberOfPlayers : 0;

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
            // Game Title
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Game Title',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.game.gameTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Court Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Court Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow('Court Name', widget.game.courtName),
                    _buildInfoRow(
                      'Court Rate',
                      '₱${widget.game.courtRate.toStringAsFixed(2)}/hour',
                    ),
                    _buildInfoRow(
                      'Shuttle Cock Price',
                      '₱${widget.game.shuttleCockPrice.toStringAsFixed(2)}',
                    ),
                    _buildInfoRow(
                      'Divide Equally',
                      widget.game.divideCourtEqually ? 'Yes' : 'No',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Schedules
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schedules',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ...widget.game.schedules.map((schedule) {
                      final duration = schedule.endTime.difference(
                        schedule.startTime,
                      );
                      final hours = duration.inMinutes / 60.0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Court ${schedule.courtNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat(
                                'EEEE, MMMM dd, yyyy',
                              ).format(schedule.startTime),
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                              '${DateFormat('hh:mm a').format(schedule.startTime)} - ${DateFormat('hh:mm a').format(schedule.endTime)}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                              'Duration: ${hours.toStringAsFixed(1)} hours',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    Text(
                      'Total Duration: ${totalHours.toStringAsFixed(1)} hours',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selected Players
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Players',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: navigateToSelectPlayers,
                          icon: const Icon(Icons.person_add, size: 18),
                          label: const Text('Add Players'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    if (widget.game.selectedPlayerNicknames.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'No players added yet.\nTap "Add Players" to select players.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          ...widget.game.selectedPlayerNicknames.map((
                            nickname,
                          ) {
                            // Find the player details
                            final player = PlayerItem.playerList.firstWhere(
                              (p) => p.nickname == nickname,
                              orElse: () => PlayerItem(
                                nickname: nickname,
                                fullName: 'Unknown',
                                contactNumber: '',
                                email: '',
                                address: '',
                                remarks: '',
                                levelStart: '',
                                levelEnd: '',
                              ),
                            );

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue[200]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue[600],
                                    child: Text(
                                      player.nickname[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          player.nickname,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          player.fullName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.group,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Total: ${widget.game.selectedPlayerNicknames.length} player(s)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Players & Costs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cost Breakdown',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),

                    // Cost Breakdown
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'Court Cost',
                            '₱${(totalHours * widget.game.courtRate).toStringAsFixed(2)}',
                          ),
                          _buildInfoRow(
                            'Shuttle Cock Cost',
                            '₱${(totalHours.ceil() * widget.game.shuttleCockPrice).toStringAsFixed(2)}',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            'Total Cost',
                            '₱${totalCost.toStringAsFixed(2)}',
                            bold: true,
                          ),
                          if (numberOfPlayers > 0) ...[
                            const Divider(),
                            _buildInfoRow(
                              'Cost Per Player',
                              '₱${costPerPlayer.toStringAsFixed(2)}',
                              bold: true,
                              color: Colors.green[700],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build a row displaying a label and value pair
  Widget _buildInfoRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
