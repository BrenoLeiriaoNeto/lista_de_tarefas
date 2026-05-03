import 'package:flutter/material.dart';

Future<bool?> showDeleteConfirmation(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Tem certeza que deseja excluir esta tarefa?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
