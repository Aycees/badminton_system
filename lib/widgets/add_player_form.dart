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

class AddPlayerForm extends StatefulWidget {
  const AddPlayerForm({super.key});

  @override
  State<AddPlayerForm> createState() => _AddPlayerFormState();
}

class _AddPlayerFormState extends State<AddPlayerForm> {
  RangeValues sliderValues = const RangeValues(0, 20);
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final _error = <String, String?>{};

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

  @override
  Widget build(BuildContext context) {
    // Function to save a new player
    void savePlayer({
      required String nickname,
      required String fullName,
      required String contactNumber,
      required String email,
      required String address,
      required String remarks,
      required String levelStart,
      required String levelEnd,
    }) {
      final newPlayer = PlayerItem(
        nickname: nickname,
        fullName: fullName,
        contactNumber: contactNumber,
        email: email,
        address: address,
        remarks: remarks,
        levelStart: levelStart,
        levelEnd: levelEnd,
      );
      PlayerItem.playerList.add(newPlayer);
    }

    bool validateFields() {
      bool valid = true;
      setState(() {
        _error['nickname'] = nicknameController.text.trim().isEmpty
            ? 'Required'
            : null;
        _error['fullName'] = fullNameController.text.trim().isEmpty
            ? 'Required'
            : null;
        _error['contactNumber'] = contactNumberController.text.trim().isEmpty
            ? 'Required'
            : null;
        _error['email'] = emailController.text.trim().isEmpty
            ? 'Required'
            : null;
        _error['address'] = addressController.text.trim().isEmpty
            ? 'Required'
            : null;
      });
      for (final v in _error.values) {
        if (v != null) valid = false;
      }
      return valid;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nicknameController,
          decoration: InputDecoration(
            labelText: 'Nickname',
            prefixIcon: const Icon(Icons.person),
            errorText: _error['nickname'],
          ),
        ),
        TextField(
          controller: fullNameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: const Icon(Icons.badge),
            errorText: _error['fullName'],
          ),
        ),
        TextField(
          controller: contactNumberController,
          decoration: InputDecoration(
            labelText: 'Contact Number',
            prefixIcon: const Icon(Icons.phone),
            errorText: _error['contactNumber'],
          ),
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            errorText: _error['email'],
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            prefixIcon: const Icon(Icons.home),
            errorText: _error['address'],
          ),
          maxLines: 3,
        ),
        TextField(
          controller: remarksController,
          decoration: const InputDecoration(
            labelText: 'Remarks',
            prefixIcon: Icon(Icons.notes),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (validateFields()) {
                    savePlayer(
                      nickname: nicknameController.text,
                      fullName: fullNameController.text,
                      contactNumber: contactNumberController.text,
                      email: emailController.text,
                      address: addressController.text,
                      remarks: remarksController.text,
                      levelStart: getLevelLabel(sliderValues.start),
                      levelEnd: getLevelLabel(sliderValues.end),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Player saved: ${nicknameController.text}',
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
          ],
        ),
      ],
    );
  }
}
