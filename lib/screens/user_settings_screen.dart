import 'package:flutter/material.dart';
import '../models/user_settings.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserSettings settings = UserSettings.instance;

  late TextEditingController courtNameController;
  late TextEditingController courtRateController;
  late TextEditingController shuttleCockPriceController;
  late bool divideCourtEqually;

  @override
  void initState() {
    super.initState();
    courtNameController = TextEditingController(
      text: settings.defaultCourtName,
    );
    courtRateController = TextEditingController(
      text: settings.defaultCourtRate.toString(),
    );
    shuttleCockPriceController = TextEditingController(
      text: settings.defaultShuttleCockPrice.toString(),
    );
    divideCourtEqually = settings.divideCourtEqually;
  }

  @override
  void dispose() {
    courtNameController.dispose();
    courtRateController.dispose();
    shuttleCockPriceController.dispose();
    super.dispose();
  }

  /// Validates and saves the user settings with updated default values
  void saveSettings() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        settings.defaultCourtName = courtNameController.text;
        settings.defaultCourtRate = double.parse(courtRateController.text);
        settings.defaultShuttleCockPrice = double.parse(
          shuttleCockPriceController.text,
        );
        settings.divideCourtEqually = divideCourtEqually;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple[100],
        title: const Text(
          'User Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Default Court Name
              TextFormField(
                controller: courtNameController,
                decoration: const InputDecoration(
                  labelText: 'Default Court Name',
                  hintText: 'Enter court name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a court name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Default Court Rate
              TextFormField(
                controller: courtRateController,
                decoration: const InputDecoration(
                  labelText: 'Default Court Rate (per hour)',
                  hintText: 'Enter rate',
                  border: OutlineInputBorder(),
                  prefixText: '₱ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a court rate';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Rate must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Default Shuttle Cock Price
              TextFormField(
                controller: shuttleCockPriceController,
                decoration: const InputDecoration(
                  labelText: 'Default Shuttle Cock Price',
                  hintText: 'Enter price per shuttle cock',
                  border: OutlineInputBorder(),
                  prefixText: '₱ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shuttle cock price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Divide Court Equally Checkbox
              CheckboxListTile(
                title: const Text('Divide the court equally among players'),
                subtitle: const Text(
                  'If unchecked, you need to find the rate per game',
                  style: TextStyle(fontSize: 12),
                ),
                value: divideCourtEqually,
                onChanged: (bool? value) {
                  setState(() {
                    divideCourtEqually = value ?? true;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[50],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              OutlinedButton(
                onPressed: () {
                  // Reset form to original values
                  setState(() {
                    courtNameController.text = settings.defaultCourtName;
                    courtRateController.text = settings.defaultCourtRate
                        .toString();
                    shuttleCockPriceController.text = settings
                        .defaultShuttleCockPrice
                        .toString();
                    divideCourtEqually = settings.divideCourtEqually;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Changes cancelled'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
