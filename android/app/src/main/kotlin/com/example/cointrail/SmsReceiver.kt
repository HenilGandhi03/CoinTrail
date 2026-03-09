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

        if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION != intent.action) return

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent) ?: return

        for (sms in messages) {
            val body = sms.messageBody ?: continue
            val lower = body.lowercase(Locale.getDefault())

            // 1. Hard block on OTPs
            if (lower.contains("otp") || lower.contains("verification code")) {
                Log.d(TAG, "⛔ OTP ignored")
                continue
            }

            // 2. Check for Currency Markers
            val hasCurrency = lower.contains("rs") || lower.contains("inr") || lower.contains("amt")
            
            // 3. Check for Transactional Action Keywords (The "Secret Sauce")
            val transactionalKeywords = listOf(
                "debited", "credited", "spent", "paid", "received", 
                "transaction", "txn", "vpa", "upi", "purchase"
            )
            val hasAction = transactionalKeywords.any { lower.contains(it) }

            // 4. Only save if it has BOTH currency and an action keyword
            if (hasCurrency && hasAction) {
                PendingSmsStore.save(context, body)
                NotificationHelper.show(context)
                Log.d(TAG, "✅ Transaction SMS saved")
            } else {
                Log.d(TAG, "⛔ Non-transactional message filtered out")
            }
        }
    }

    companion object {
        private const val TAG = "CoinTrailSms"
    }
}