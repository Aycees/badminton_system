import 'package:flutter/material.dart';

class PlayersList extends StatelessWidget {
  PlayersList({super.key});

  final List<String> players = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    'Player 5',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(players[index]),
        );
      },
    );
  }
}
