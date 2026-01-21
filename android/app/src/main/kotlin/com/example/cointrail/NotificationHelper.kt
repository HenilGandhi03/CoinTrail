package com.example.cointrail

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat

object NotificationHelper {
    private const val TAG = "CoinTrailSms"
    private const val CHANNEL_ID = "pending_transactions"

    fun show(context: Context) {
        Log.d(TAG, "🔔 Preparing notification")

        val manager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (manager == null) {
            Log.d(TAG, "❌ NotificationManager null")
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Pending Transactions",
                NotificationManager.IMPORTANCE_HIGH
            )
            manager.createNotificationChannel(channel)
            Log.d(TAG, "📢 Notification channel created")
        }

        val builder =
            NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("Transaction detected")
                .setContentText("Tap to review pending transactions")
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)

        manager.notify(1001, builder.build())
        Log.d(TAG, "✅ Notification shown")
    }
}