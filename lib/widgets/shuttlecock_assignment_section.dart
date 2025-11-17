import 'package:flutter/material.dart';
import '../models/game_item.dart';

class ShuttlecockAssignmentSection extends StatelessWidget {
  final GameItem game;
  final Function(bool divideEqually, String? payerNickname) onAssignmentChanged;

  const ShuttlecockAssignmentSection({
    super.key,
    required this.game,
    required this.onAssignmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shuttlecock Cost Assignment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            RadioListTile<bool>(
              title: const Text('Divide Equally Among All Players'),
              value: true,
              groupValue: game.divideShuttleCockEqually,
              onChanged: (value) {
                if (value != null) {
                  onAssignmentChanged(true, null);
                }
              },
            ),
            RadioListTile<bool>(
              title: const Text('Assign to Specific Player'),
              value: false,
              groupValue: game.divideShuttleCockEqually,
              onChanged: game.selectedPlayerNicknames.isEmpty
                  ? null
                  : (value) {
                      if (value != null) {
                        _showPlayerSelectionDialog(context);
                      }
                    },
            ),
            if (!game.divideShuttleCockEqually &&
                game.shuttleCockPayerNickname != null)
              Container(
                margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Assigned to: ${game.shuttleCockPayerNickname}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showPlayerSelectionDialog(context),
                      tooltip: 'Change player',
                    ),
                  ],
                ),
              ),
            if (game.selectedPlayerNicknames.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Add players first to assign shuttlecock cost',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPlayerSelectionDialog(BuildContext context) {
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
                    onAssignmentChanged(false, nickname);
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
}
