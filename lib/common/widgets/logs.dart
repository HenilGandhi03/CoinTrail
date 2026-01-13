import 'package:flutter/material.dart';

void logGreen(String message) {
  debugPrint('\x1B[32m$message\x1B[0m');
}

// usage
// logGreen('Updating username for UID: $uid to "$name"');
