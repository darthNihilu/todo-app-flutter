import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const TaskListItem({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // contentPadding: EdgeInsets.zero,
      // minVerticalPadding: 0,
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
      leading: Checkbox(
        value: false, // Set the initial checkbox value as needed
        onChanged: (bool? value) {
          // Handle checkbox state changes here
        },
      ),
      onTap: () {
        // Handle item tap here
      },
    );
  }
}
