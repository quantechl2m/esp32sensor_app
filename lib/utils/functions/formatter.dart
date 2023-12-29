import 'package:intl/intl.dart';

String dateFormatter(DateTime date) {
  return DateFormat('E dd/mm/yyyy • hh:mm a').format(date);
}