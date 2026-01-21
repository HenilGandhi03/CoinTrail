package com.example.cointrail

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.util.Log
import java.util.Locale


class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "🚀 SmsReceiver triggered")

        if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION != intent.action) {
            Log.d(TAG, "❌ Not SMS_RECEIVED_ACTION")
            return
        }

        val messages =
            Telephony.Sms.Intents.getMessagesFromIntent(intent)

        if (messages == null) {
            Log.d(TAG, "❌ Messages null")
            return
        }

        for (sms in messages) {
            val body = sms.messageBody
            Log.d(TAG, "📩 SMS body: $body")

            if (body == null) continue

            val lower = body.lowercase(Locale.getDefault())

            if (lower.contains("otp")) {
                Log.d(TAG, "⛔ OTP ignored")
                continue
            }

            if (!lower.contains("rs") && !lower.contains("inr")) {
                Log.d(TAG, "⛔ Not a transaction SMS")
                continue
            }

            PendingSmsStore.save(context, body)
            Log.d(TAG, "✅ SMS saved to PendingSmsStore")
        }

        NotificationHelper.show(context)
        Log.d(TAG, "🔔 Notification triggered")
    }

    companion object {
        private const val TAG = "CoinTrailSms"
    }
}