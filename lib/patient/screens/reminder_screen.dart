import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool reminderEnabled = true;

  TimeOfDay reminderTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Reminder',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Choose a time to remind you about your daily activity.',
                style: TextStyle(fontSize: 18, height: 1.4),
              ),

              const SizedBox(height: 30),

              // --------------------------------------------------
              // REMINDER ON/OFF
              // --------------------------------------------------
              Card(
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),

                  title: const Text(
                    'Daily reminder',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  subtitle: Text(
                    reminderEnabled
                        ? 'Your reminder is on'
                        : 'Your reminder is off',
                    style: const TextStyle(fontSize: 16),
                  ),

                  value: reminderEnabled,

                  onChanged: (value) {
                    setState(() {
                      reminderEnabled = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // REMINDER TIME
              // --------------------------------------------------
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),

                  leading: const Icon(Icons.access_time, size: 32),

                  title: const Text(
                    'Reminder time',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  subtitle: Text(
                    reminderTime.format(context),
                    style: const TextStyle(fontSize: 18),
                  ),

                  trailing: const Icon(Icons.chevron_right, size: 30),

                  onTap: reminderEnabled ? _selectReminderTime : null,
                ),
              ),

              const Spacer(),

              // --------------------------------------------------
              // BACK
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectReminderTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );

    if (selectedTime != null) {
      setState(() {
        reminderTime = selectedTime;
      });
    }
  }
}
