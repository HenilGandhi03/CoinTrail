package com.example.cointrail

import android.content.Context
import android.util.Log
import org.json.JSONArray

object PendingSmsStore {

    private const val TAG = "CoinTrailSms"
    private const val PREFS = "pending_sms_store"
    private const val KEY_SMS = "items"

    // ─────────────────────────────────────────────
    // Save SMS (called from SmsReceiver — killed state safe)
    // ─────────────────────────────────────────────
    fun save(context: Context, sms: String) {
        try {
            Log.d(TAG, "💾 Saving SMS")

            val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val raw = prefs.getString(KEY_SMS, "[]") ?: "[]"

            val array = JSONArray(raw)
            
            // Check for duplicates before adding
            for (i in 0 until array.length()) {
                if (array.getString(i) == sms) {
                    Log.d(TAG, "⚠️ Duplicate SMS ignored")
                    return
                }
            }

            array.put(sms)
            prefs.edit().putString(KEY_SMS, array.toString()).apply()

            Log.d(TAG, "✅ SMS stored. Total: ${array.length()}")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error saving SMS", e)
        }
    }

    // ─────────────────────────────────────────────
    // Get all pending SMS (called from Flutter)
    // ─────────────────────────────────────────────
    fun getAll(context: Context): List<String> {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val raw = prefs.getString(KEY_SMS, "[]") ?: "[]"

        val result = mutableListOf<String>()

        try {
            val array = JSONArray(raw)
            for (i in 0 until array.length()) {
                result.add(array.getString(i))
            }
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error reading SMS", e)
        }

        Log.d(TAG, "📤 Returning ${result.size} SMS to Flutter")
        return result
    }

    // ─────────────────────────────────────────────
    // Clear after Flutter sync
    // ─────────────────────────────────────────────
    fun clear(context: Context) {
        Log.d(TAG, "🧹 Clearing pending SMS")
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        prefs.edit().remove(KEY_SMS).apply()
    }
}
