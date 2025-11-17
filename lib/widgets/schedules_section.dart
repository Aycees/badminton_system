import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game_item.dart';

class SchedulesSection extends StatelessWidget {
  final GameItem game;

  const SchedulesSection({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final totalHours = game.getTotalHours();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedules',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...game.schedules.map((schedule) {
              final duration = schedule.endTime.difference(schedule.startTime);
              final hours = duration.inMinutes / 60.0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Court ${schedule.courtNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'EEEE, MMMM dd, yyyy',
                      ).format(schedule.startTime),
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      '${DateFormat('hh:mm a').format(schedule.startTime)} - ${DateFormat('hh:mm a').format(schedule.endTime)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Duration: ${hours.toStringAsFixed(1)} hours',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Text(
              'Total Duration: ${totalHours.toStringAsFixed(1)} hours',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
