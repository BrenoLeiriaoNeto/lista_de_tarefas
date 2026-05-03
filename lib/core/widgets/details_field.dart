import 'package:flutter/material.dart';

class DetailsField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const DetailsField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: .w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: .circular(10),
            border: .all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(value, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
