import 'package:badminton_system/widgets/add_player_input.dart';
import 'package:flutter/material.dart';

class AddPlayerScreen extends StatelessWidget {
  const AddPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Player'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: AddPlayerInput(),
      ),
    );
  }
}
