import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Nickname',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.badge),
          ),
        ),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Contact Number',
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Address',
            prefixIcon: Icon(Icons.home),
          ),
          maxLines: 3,
        ),
        const TextField(
          decoration: InputDecoration(
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
                  // Add save logic here
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
