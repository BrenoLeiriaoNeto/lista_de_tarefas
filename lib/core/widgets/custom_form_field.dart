import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool? enabled;
  final String? Function(String?)? validator;
  const CustomFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.enabled,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (validator == null) {
      return TextFormField(
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(color: Colors.black54),
            ),
          ),
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      );
    }
    return TextFormField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: Colors.black54),
            children: <TextSpan>[
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
