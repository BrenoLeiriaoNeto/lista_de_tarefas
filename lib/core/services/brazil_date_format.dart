import 'package:intl/intl.dart';

String brazilDateFormat(DateTime data) =>
    DateFormat("dd/MM/yyyy HH:mm", "pt_BR").format(data);
