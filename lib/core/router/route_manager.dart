import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/core/router/app_routes.dart';
import 'package:lista_de_tarefas/features/tasks/tasks_features.dart';

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.tasksList:
        return MaterialPageRoute(builder: (_) => const TasksListPage());

      case AppRoutes.taskCreation:
        return MaterialPageRoute(builder: (_) => TaskCreatePage());

      case AppRoutes.taskDetails:
        final args = settings.arguments as Task;
        return MaterialPageRoute(builder: (_) => TaskDetailsPage(task: args));

      case AppRoutes.taskUpdate:
        final args = settings.arguments as Task;
        return MaterialPageRoute(builder: (_) => TaskUpdatePage(task: args));

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}
