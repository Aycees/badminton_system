import 'package:flutter/material.dart';
import '../models/player_item.dart';

const badmintonLevels = [
  {
    'label': 'Beginner',
    'marks': ['Weak', 'Mid', 'Strong'],
  },
  {
    'label': 'Intermediate',
    'marks': ['Weak', 'Mid', 'Strong'],
  },
  {
    'label': 'Level G',
    'marks': ['Weak', 'Mid', 'Strong'],
  },
  {
    'label': 'Level F',
    'marks': ['Weak', 'Mid', 'Strong'],
  },
  {
    'label': 'Level E',
    'marks': ['Weak', 'Mid', 'Strong'],
  },
  {
    'label': 'Level D',
    'marks': ['Weak', 'Mid', 'Strong'],
  },
  {
    'label': 'Open',
    'marks': [],
  },
];

class EditPlayerForm extends StatefulWidget {
  final PlayerItem player;
  final Function(PlayerItem) onPlayerUpdated;
  final Function(PlayerItem) onPlayerDeleted;

  const EditPlayerForm({
    super.key,
    required this.player,
    required this.onPlayerUpdated,
    required this.onPlayerDeleted,
  });

  @override
  State<EditPlayerForm> createState() => _EditPlayerFormState();
}

class _EditPlayerFormState extends State<EditPlayerForm> {
  late RangeValues sliderValues;
  late TextEditingController nicknameController;
  late TextEditingController fullNameController;
  late TextEditingController contactNumberController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController remarksController;
  final _error = <String, String?>{};

  @override
  void initState() {
    super.initState();
    // Pre-fill form fields with existing player data
    nicknameController = TextEditingController(text: widget.player.nickname);
    fullNameController = TextEditingController(text: widget.player.fullName);
    contactNumberController = TextEditingController(
      text: widget.player.contactNumber,
    );
    emailController = TextEditingController(text: widget.player.email);
    addressController = TextEditingController(text: widget.player.address);
    remarksController = TextEditingController(text: widget.player.remarks);

    // Set slider values based on current player levels
    sliderValues = RangeValues(
      getLevelValue(widget.player.levelStart),
      getLevelValue(widget.player.levelEnd),
    );
  }

  @override
  void dispose() {
    nicknameController.dispose();
    fullNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  /// Converts a level string back to its corresponding slider value
  double getLevelValue(String levelString) {
    // Convert level string back to slider value
    for (int i = 0; i < badmintonLevels.length; i++) {
      final level = badmintonLevels[i];
      final levelLabel = level['label'] as String;
      final marks = (level['marks'] as List).cast<String>();

      if (marks.isEmpty) {
        // For "Open" level
        if (levelString == levelLabel) {
          return i * 3.0;
        }
      } else {
        // For levels with marks
        for (int j = 0; j < marks.length; j++) {
          String fullLabel = '$levelLabel (${marks[j]})';
          if (levelString == fullLabel) {
            return i * 3.0 + j;
          }
        }
      }
    }
    return 0.0; // Default to first level if not found
  }

  /// Converts a slider value to its corresponding badminton level label with mark
  String getLevelLabel(double value) {
    int idx = value ~/ 3;
    int markIdx = value % 3 == 0
        ? 0
        : value % 3 == 1
        ? 1
        : 2;
    final level = badmintonLevels[idx];
    final marks = (level['marks'] as List).cast<String>();
    // For Open, no marks
    if (marks.isEmpty) return level['label'] as String;
    return '${level['label']} (${marks[markIdx]})';
  }

  /// Validates all form fields and returns true if all fields are valid
  bool validateFields() {
    bool valid = true;
    setState(() {
      _error['nickname'] = nicknameController.text.trim().isEmpty
          ? 'Nickname Required'
          : null;
      _error['fullName'] = fullNameController.text.trim().isEmpty
          ? 'Fullname Required'
          : null;
      _error['contactNumber'] = contactNumberController.text.trim().isEmpty
          ? 'Contact Number Required'
          : null;
      _error['email'] = emailController.text.trim().isEmpty
          ? 'Email Required'
          : null;
      _error['address'] = addressController.text.trim().isEmpty
          ? 'Address Required'
          : null;
    });
    final contact = contactNumberController.text.trim();
    if (contact.isEmpty) {
      _error['contactNumber'] = 'Contact Number Required';
    } else if (!RegExp(r'^\d+$').hasMatch(contact)) {
      _error['contactNumber'] = 'Numbers only';
    } else {
      _error['contactNumber'] = null;
    }
    for (final v in _error.values) {
      if (v != null) valid = false;
    }
    return valid;
  }

  /// Updates the player with new information and saves to the player list
  void updatePlayer() {
    if (validateFields()) {
      final updatedPlayer = PlayerItem(
        nickname: nicknameController.text.trim(),
        fullName: fullNameController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        remarks: remarksController.text.trim(),
        levelStart: getLevelLabel(sliderValues.start),
        levelEnd: getLevelLabel(sliderValues.end),
      );

      // Find and update the player in the main list
      final index = PlayerItem.playerList.indexOf(widget.player);
      if (index != -1) {
        PlayerItem.playerList[index] = updatedPlayer;
      }

      widget.onPlayerUpdated(updatedPlayer);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Player updated: ${nicknameController.text}'),
        ),
      );
      Navigator.pop(context);
    }
  }

  /// Shows a confirmation dialog and deletes the player if confirmed
  Future<void> deletePlayer() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text(
            'Are you sure you want to permanently delete "${widget.player.nickname}" (${widget.player.fullName})? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      PlayerItem.playerList.remove(widget.player);
      widget.onPlayerDeleted(widget.player);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.player.nickname} has been deleted'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...[
            {
              'controller': nicknameController,
              'label': 'Nickname',
              'icon': const Icon(Icons.person),
              'error': _error['nickname'],
              'maxLines': 1,
            },
            {
              'controller': fullNameController,
              'label': 'Full Name',
              'icon': const Icon(Icons.badge),
              'error': _error['fullName'],
              'maxLines': 1,
            },
            {
              'controller': contactNumberController,
              'label': 'Contact Number',
              'icon': const Icon(Icons.phone),
              'error': _error['contactNumber'],
              'maxLines': 1,
            },
            {
              'controller': emailController,
              'label': 'Email',
              'icon': const Icon(Icons.email),
              'error': _error['email'],
              'maxLines': 1,
              'keyboardType': TextInputType.emailAddress,
            },
            {
              'controller': addressController,
              'label': 'Address',
              'icon': const Icon(Icons.home),
              'error': _error['address'],
              'maxLines': 3,
            },
            {
              'controller': remarksController,
              'label': 'Remarks',
              'icon': const Icon(Icons.notes),
              'error': null,
              'maxLines': 3,
            },
          ].map(
            (field) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(14),
                child: TextField(
                  controller: field['controller'] as TextEditingController,
                  decoration: InputDecoration(
                    labelText: field['label'] as String,
                    prefixIcon: field['icon'] as Widget,
                    errorText: field['error'] as String?,
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                  maxLines: field['maxLines'] as int,
                  keyboardType: field['keyboardType'] as TextInputType?,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Skill Level',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RangeSlider(
                min: 0,
                max: 20,
                divisions: 20,
                labels: RangeLabels(
                  getLevelLabel(sliderValues.start),
                  getLevelLabel(sliderValues.end),
                ),
                values: sliderValues,
                onChanged: (values) {
                  setState(() {
                    sliderValues = values;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Selected: ${getLevelLabel(sliderValues.start)} to ${getLevelLabel(sliderValues.end)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              // Update Player Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updatePlayer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Update Player',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Delete Player Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: deletePlayer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Delete Player',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
