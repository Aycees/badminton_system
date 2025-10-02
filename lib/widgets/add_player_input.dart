import 'package:flutter/material.dart';

class AddPlayerInput extends StatelessWidget {
  const AddPlayerInput({super.key});

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
