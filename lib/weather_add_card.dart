import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String num;
  const CardItem({
    super.key,
    required this.icon,
    required this.num,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 0,
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(num)
        ],
      ),
    );
  }
}
