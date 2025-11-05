import 'package:flutter/material.dart';
import '../models/player_item.dart';

class SelectPlayersScreen extends StatefulWidget {
  final List<String> selectedPlayerNicknames;
  final Function(List<String>) onPlayersSelected;

  const SelectPlayersScreen({
    super.key,
    required this.selectedPlayerNicknames,
    required this.onPlayersSelected,
  });

  @override
  State<SelectPlayersScreen> createState() => _SelectPlayersScreenState();
}

class _SelectPlayersScreenState extends State<SelectPlayersScreen> {
  late List<String> tempSelectedPlayers;

  @override
  void initState() {
    super.initState();
    tempSelectedPlayers = List.from(widget.selectedPlayerNicknames);
  }

  void togglePlayerSelection(String nickname) {
    setState(() {
      if (tempSelectedPlayers.contains(nickname)) {
        tempSelectedPlayers.remove(nickname);
      } else {
        tempSelectedPlayers.add(nickname);
      }
    });
  }

  void saveSelection() {
    widget.onPlayersSelected(tempSelectedPlayers);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Players'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.purple[50],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: saveSelection,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: PlayerItem.playerList.isEmpty
          ? const Center(
              child: Text(
                'No players available.\nAdd players first!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              children: [
                // Header with count
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected: ${tempSelectedPlayers.length} player(s)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (tempSelectedPlayers.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              tempSelectedPlayers.clear();
                            });
                          },
                          child: const Text('Clear All'),
                        ),
                    ],
                  ),
                ),
                // Player list
                Expanded(
                  child: ListView.builder(
                    itemCount: PlayerItem.playerList.length,
                    itemBuilder: (context, index) {
                      final player = PlayerItem.playerList[index];
                      final isSelected = tempSelectedPlayers.contains(
                        player.nickname,
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: isSelected ? 4 : 1,
                        color: isSelected ? Colors.blue[50] : Colors.white,
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: (bool? value) {
                            togglePlayerSelection(player.nickname);
                          },
                          title: Text(
                            player.nickname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSelected
                                  ? Colors.blue[900]
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.fullName,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${player.levelStart} → ${player.levelEnd}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          secondary: CircleAvatar(
                            backgroundColor: isSelected
                                ? Colors.blue[600]
                                : Colors.grey[400],
                            child: Text(
                              player.nickname[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          activeColor: Colors.blue[700],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
