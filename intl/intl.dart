import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

DateTime parseDateString(String dateString) {
  return DateFormat('dd/MM/yyyy').parse(dateString);
}
