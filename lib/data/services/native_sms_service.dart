// lib/data/services/native_sms_service.dart
import 'package:flutter/services.dart';

class NativeSmsService {
  static const _channel = MethodChannel('cointrail/sms');

  static Future<List<String>> getPendingSms() async {
    final List<dynamic> result = await _channel.invokeMethod('getPendingSms');
    return result.cast<String>();
  }

  static Future<void> clearPendingSms() async {
    await _channel.invokeMethod('clearPendingSms');
  }
}
