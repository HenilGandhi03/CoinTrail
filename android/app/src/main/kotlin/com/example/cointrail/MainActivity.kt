package com.example.cointrail

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "cointrail/sms"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "getPendingSms" -> {
                    val smsList = PendingSmsStore.getAll(this)
                    result.success(smsList)
                }

                "clearPendingSms" -> {
                    PendingSmsStore.clear(this)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
