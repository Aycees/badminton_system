import 'package:flutter/material.dart';
import '../models/player_item.dart';
import '../widgets/edit_player_form.dart';

class EditPlayerScreen extends StatelessWidget {
  final PlayerItem player;
  final Function(PlayerItem) onPlayerUpdated;
  final Function(PlayerItem) onPlayerDeleted;

  const EditPlayerScreen({
    super.key,
    required this.player,
    required this.onPlayerUpdated,
    required this.onPlayerDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Player Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EditPlayerForm(
          player: player,
          onPlayerUpdated: onPlayerUpdated,
          onPlayerDeleted: onPlayerDeleted,
        ),
      ),
    );
  }
}
