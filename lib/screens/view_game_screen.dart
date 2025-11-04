import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game_item.dart';

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

  void updatePlayerCount(int count) {
    setState(() {
      numberOfPlayers = count;
      widget.game.numberOfPlayers = count;
    });
  }

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

            // Players & Costs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Players & Costs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),

                    // Number of Players
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Number of Players',
                          style: TextStyle(fontSize: 14),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: numberOfPlayers > 0
                                  ? () => updatePlayerCount(numberOfPlayers - 1)
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$numberOfPlayers',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () =>
                                  updatePlayerCount(numberOfPlayers + 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
