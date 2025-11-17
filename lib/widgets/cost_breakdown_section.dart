import 'package:flutter/material.dart';
import '../models/game_item.dart';

class CostBreakdownSection extends StatelessWidget {
  final GameItem game;
  final int numberOfPlayers;

  const CostBreakdownSection({
    super.key,
    required this.game,
    required this.numberOfPlayers,
  });

  @override
  Widget build(BuildContext context) {
    final totalCost = game.getTotalCost();
    final totalHours = game.getTotalHours();
    final courtCost = totalHours * game.courtRate;
    final shuttleCockCost = totalHours.ceil() * game.shuttleCockPrice;

    // Calculate cost per player based on shuttlecock assignment
    final Map<String, double> playerCosts = _calculatePlayerCosts(
      courtCost,
      shuttleCockCost,
    );

    return Card(
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
                    '₱${courtCost.toStringAsFixed(2)}',
                  ),
                  _buildInfoRow(
                    'Shuttle Cock Cost',
                    '₱${shuttleCockCost.toStringAsFixed(2)}',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Total Cost',
                    '₱${totalCost.toStringAsFixed(2)}',
                    bold: true,
                  ),
                  if (numberOfPlayers > 0) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Cost Per Player:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Divider(),
                    ...playerCosts.entries.map((entry) {
                      final isShuttlePayer =
                          !game.divideShuttleCockEqually &&
                          game.shuttleCockPayerNickname == entry.key;
                      final isCourtPayer =
                          !game.divideCourtEqually &&
                          game.courtPayerNicknames.contains(entry.key);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          (isShuttlePayer || isCourtPayer)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  if (isCourtPayer) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.store,
                                      size: 14,
                                      color: Colors.blue[700],
                                    ),
                                  ],
                                  if (isShuttlePayer) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.sports_tennis,
                                      size: 14,
                                      color: Colors.orange[700],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Text(
                              '₱${entry.value.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: (isShuttlePayer || isCourtPayer)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calculatePlayerCosts(
    double courtCost,
    double shuttleCockCost,
  ) {
    final Map<String, double> costs = {};

    if (numberOfPlayers == 0) return costs;

    // Calculate court cost per player
    double courtCostPerPlayer;
    if (game.divideCourtEqually) {
      courtCostPerPlayer = courtCost / numberOfPlayers;
    } else if (game.courtPayerNicknames.isNotEmpty) {
      courtCostPerPlayer = courtCost / game.courtPayerNicknames.length;
    } else {
      courtCostPerPlayer = 0;
    }

    for (final nickname in game.selectedPlayerNicknames) {
      double playerCost = 0;

      // Add court cost
      if (game.divideCourtEqually) {
        playerCost += courtCostPerPlayer;
      } else if (game.courtPayerNicknames.contains(nickname)) {
        playerCost += courtCostPerPlayer;
      }

      // Add shuttlecock cost
      if (game.divideShuttleCockEqually) {
        final shuttleCostPerPlayer = shuttleCockCost / numberOfPlayers;
        playerCost += shuttleCostPerPlayer;
      } else if (game.shuttleCockPayerNickname == nickname) {
        playerCost += shuttleCockCost;
      }

      costs[nickname] = playerCost;
    }

    return costs;
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
