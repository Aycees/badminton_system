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

    return Column(
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
