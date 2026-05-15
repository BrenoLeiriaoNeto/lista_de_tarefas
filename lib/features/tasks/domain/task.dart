import 'package:lista_de_tarefas/features/tasks/domain/geo_location.dart';

class Task {
  final String nome;
  final DateTime dataHora;
  final GeoLocation localizacao;

  const Task({
    required this.nome,
    required this.dataHora,
    required this.localizacao,
  });
}
