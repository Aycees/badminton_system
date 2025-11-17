import 'package:flutter/material.dart';
import '../models/game_item.dart';

class CourtInformationSection extends StatelessWidget {
  final GameItem game;
  final Function(bool divideEqually, List<String> payerNicknames)?
  onCourtAssignmentChanged;
  final Function(bool divideEqually, String? payerNickname)?
  onShuttlecockAssignmentChanged;
  final VoidCallback? onEditCourtInfo;

  const CourtInformationSection({
    super.key,
    required this.game,
    this.onCourtAssignmentChanged,
    this.onShuttlecockAssignmentChanged,
    this.onEditCourtInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Court Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (onCourtAssignmentChanged != null)
                      IconButton(
                        icon: const Icon(Icons.payments, size: 20),
                        onPressed: () => _showCourtCostSettingsDialog(context),
                        tooltip: 'Court Cost Settings',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    if (onShuttlecockAssignmentChanged != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.sports_tennis, size: 20),
                        onPressed: () =>
                            _showShuttlecockSettingsDialog(context),
                        tooltip: 'Shuttlecock Cost Settings',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                    if (onEditCourtInfo != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onEditCourtInfo,
                        tooltip: 'Edit Court Info',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow('Court Name', game.courtName),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Court Rate',
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    if (!game.divideCourtEqually &&
                        game.courtPayerNicknames.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people,
                              size: 12,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${game.courtPayerNicknames.length}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      '₱${game.courtRate.toStringAsFixed(2)}/hour',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Shuttle Cock Price',
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    if (!game.divideShuttleCockEqually &&
                        game.shuttleCockPayerNickname != null)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person,
                              size: 12,
                              color: Colors.orange[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              game.shuttleCockPayerNickname!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      '₱${game.shuttleCockPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showShuttlecockSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Shuttlecock Cost Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Divide Equally'),
                subtitle: const Text('Split cost among all players'),
                trailing: game.divideShuttleCockEqually
                    ? Icon(Icons.check_circle, color: Colors.green[700])
                    : null,
                onTap: () {
                  onShuttlecockAssignmentChanged?.call(true, null);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Assign to Player'),
                subtitle: const Text('One player pays for shuttlecock'),
                trailing: !game.divideShuttleCockEqually
                    ? Icon(Icons.check_circle, color: Colors.green[700])
                    : null,
                enabled: game.selectedPlayerNicknames.isNotEmpty,
                onTap: game.selectedPlayerNicknames.isEmpty
                    ? null
                    : () {
                        Navigator.pop(context);
                        _showShuttlecockPlayerSelectionDialog(context);
                      },
              ),
              if (game.selectedPlayerNicknames.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add players first to assign shuttlecock cost',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showShuttlecockPlayerSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Player'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: game.selectedPlayerNicknames.length,
              itemBuilder: (context, index) {
                final nickname = game.selectedPlayerNicknames[index];
                final isSelected = game.shuttleCockPayerNickname == nickname;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? Colors.orange
                        : Colors.blue[600],
                    child: Text(
                      nickname[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    nickname,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Colors.orange[700])
                      : null,
                  onTap: () {
                    onShuttlecockAssignmentChanged?.call(false, nickname);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showCourtCostSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Court Cost Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Divide Equally'),
                subtitle: const Text('Split cost among all players'),
                trailing: game.divideCourtEqually
                    ? Icon(Icons.check_circle, color: Colors.green[700])
                    : null,
                onTap: () {
                  onCourtAssignmentChanged?.call(true, []);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Assign to Player(s)'),
                subtitle: const Text('Select one or more players'),
                trailing: !game.divideCourtEqually
                    ? Icon(Icons.check_circle, color: Colors.green[700])
                    : null,
                enabled: game.selectedPlayerNicknames.isNotEmpty,
                onTap: game.selectedPlayerNicknames.isEmpty
                    ? null
                    : () {
                        Navigator.pop(context);
                        _showPlayersSelectionDialog(context);
                      },
              ),
              if (game.selectedPlayerNicknames.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add players first to assign court cost',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPlayersSelectionDialog(BuildContext context) {
    List<String> selectedPayers = List.from(game.courtPayerNicknames);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Player(s)'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedPayers.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.blue[700],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${selectedPayers.length} player(s) selected',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: game.selectedPlayerNicknames.length,
                        itemBuilder: (context, index) {
                          final nickname = game.selectedPlayerNicknames[index];
                          final isSelected = selectedPayers.contains(nickname);

                          return CheckboxListTile(
                            secondary: CircleAvatar(
                              backgroundColor: isSelected
                                  ? Colors.blue[600]
                                  : Colors.grey,
                              child: Text(
                                nickname[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              nickname,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  if (!selectedPayers.contains(nickname)) {
                                    selectedPayers.add(nickname);
                                  }
                                } else {
                                  selectedPayers.remove(nickname);
                                }
                              });
                            },
                          );
                        },
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
                  onPressed: selectedPayers.isEmpty
                      ? null
                      : () {
                          onCourtAssignmentChanged?.call(false, selectedPayers);
                          Navigator.pop(context);
                        },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
