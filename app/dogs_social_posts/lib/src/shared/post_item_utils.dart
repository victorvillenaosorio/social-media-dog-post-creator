import 'package:flutter/material.dart';

Color getScheduledDateColor(DateTime? scheduledDate) {
  if (scheduledDate == null) {
    return Colors.red;
  } else if (scheduledDate.isAfter(DateTime.now())) {
    return Colors.blue;
  } else {
    return Colors.green;
  }
}