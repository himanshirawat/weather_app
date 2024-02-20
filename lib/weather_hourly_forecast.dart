import 'package:flutter/material.dart';

class Hourlyforecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String num;
  final Color color;

  const Hourlyforecast({
    super.key,
    required this.icon,
    required this.num,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(num),
          ],
        ),
      ),
    );
  }
}
