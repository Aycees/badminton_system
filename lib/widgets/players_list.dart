import 'package:flutter/material.dart';
import '../models/player_item.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({super.key});

  @override
  Widget build(BuildContext context) {
    final players = PlayerItem.dummyPlayers;
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(player.nickname),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(player.fullName),
              Text(
                'Level: ${player.levelStart} to ${player.levelEnd}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
