import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game_item.dart';
import '../models/user_settings.dart';

class AddGameScreen extends StatefulWidget {
  const AddGameScreen({super.key});

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserSettings settings = UserSettings.instance;

  late TextEditingController gameTitleController;
  late TextEditingController courtNameController;
  late TextEditingController courtRateController;
  late TextEditingController shuttleCockPriceController;
  late bool divideCourtEqually;

  List<CourtSchedule> schedules = [];

  @override
  void initState() {
    super.initState();
    gameTitleController = TextEditingController();
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
    gameTitleController.dispose();
    courtNameController.dispose();
    courtRateController.dispose();
    shuttleCockPriceController.dispose();
    super.dispose();
  }

  void addSchedule() async {
    // Show dialog to add court schedule
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddScheduleDialog(
          onScheduleAdded: (schedule) {
            setState(() {
              schedules.add(schedule);
            });
          },
        );
      },
    );
  }

  void removeSchedule(int index) {
    setState(() {
      schedules.removeAt(index);
    });
  }

  void saveGame() {
    if (_formKey.currentState!.validate()) {
      if (schedules.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one schedule'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // If game title is blank, use the first scheduled date as title
      String finalGameTitle = gameTitleController.text.trim();
      if (finalGameTitle.isEmpty) {
        finalGameTitle = DateFormat(
          'MMM dd, yyyy',
        ).format(schedules.first.startTime);
      }

      final newGame = GameItem(
        gameTitle: finalGameTitle,
        courtName: courtNameController.text,
        schedules: schedules,
        courtRate: double.parse(courtRateController.text),
        shuttleCockPrice: double.parse(shuttleCockPriceController.text),
        divideCourtEqually: divideCourtEqually,
      );

      GameItem.gameList.add(newGame);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Game saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Game Title
              TextFormField(
                controller: gameTitleController,
                decoration: const InputDecoration(
                  labelText: 'Game Title (Optional)',
                  hintText: 'Leave blank to use scheduled date',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Court Name
              TextFormField(
                controller: courtNameController,
                decoration: const InputDecoration(
                  labelText: 'Court Name',
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

              // Court Rate
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

              // Shuttle Cock Price
              TextFormField(
                controller: shuttleCockPriceController,
                decoration: const InputDecoration(
                  labelText: 'Shuttle Cock Price',
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
                value: divideCourtEqually,
                onChanged: (bool? value) {
                  setState(() {
                    divideCourtEqually = value ?? true;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // Schedules Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Schedules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: addSchedule,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Schedule'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Display schedules
              if (schedules.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No schedules added yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...schedules.asMap().entries.map((entry) {
                  int index = entry.key;
                  CourtSchedule schedule = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('Court ${schedule.courtNumber}'),
                      subtitle: Text(
                        '${DateFormat('MMM dd, yyyy - hh:mm a').format(schedule.startTime)} to ${DateFormat('hh:mm a').format(schedule.endTime)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeSchedule(index),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 32),

              // Save Game Button
              ElevatedButton(
                onPressed: saveGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Save Game',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
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

// Dialog to add a schedule
class AddScheduleDialog extends StatefulWidget {
  final Function(CourtSchedule) onScheduleAdded;

  const AddScheduleDialog({super.key, required this.onScheduleAdded});

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController courtNumberController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);

  @override
  void dispose() {
    courtNumberController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  void addSchedule() {
    if (_formKey.currentState!.validate()) {
      final startDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startTime.hour,
        startTime.minute,
      );

      final endDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        endTime.hour,
        endTime.minute,
      );

      if (endDateTime.isBefore(startDateTime) ||
          endDateTime.isAtSameMomentAs(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final schedule = CourtSchedule(
        courtNumber: int.parse(courtNumberController.text),
        startTime: startDateTime,
        endTime: endDateTime,
      );

      widget.onScheduleAdded(schedule);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Schedule'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Court Number
              TextFormField(
                controller: courtNumberController,
                decoration: const InputDecoration(
                  labelText: 'Court Number',
                  hintText: 'e.g., 1, 2, 3',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter court number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Court number must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: const Text('Date'),
                subtitle: Text(
                  DateFormat('MMMM dd, yyyy').format(selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: selectDate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 16),

              // Start Time Picker
              ListTile(
                title: const Text('Start Time'),
                subtitle: Text(startTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: selectStartTime,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 16),

              // End Time Picker
              ListTile(
                title: const Text('End Time'),
                subtitle: Text(endTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: selectEndTime,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: addSchedule,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
