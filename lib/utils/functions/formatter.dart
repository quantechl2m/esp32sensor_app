import 'package:intl/intl.dart';

String dateFormatter(DateTime date) {
  return DateFormat('E dd/MM/yyyy hh:mm').format(date);
}