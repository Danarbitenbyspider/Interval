package com.bitenbyspider.intervals

import android.media.AudioManager
import android.media.ToneGenerator
import io.flutter.plugin.common.MethodChannel

object BeepPlayer {
    private const val CHANNEL = "com.example.intervals_training/beep"
    private var toneGenerator: ToneGenerator? = null

    fun setupMethodChannel(messenger: io.flutter.plugin.common.BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "playBeep" -> {
                    playBeep()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun playBeep() {
        try {
            // Create ToneGenerator with music stream type for better audibility
            // Volume: 0-100, we use 80 for loud but not max
            val toneGen = ToneGenerator(AudioManager.STREAM_MUSIC, 80)

            // Play a dual-tone beep (two tones for better audibility)
            toneGen.startTone(ToneGenerator.TONE_PROP_BEEP, 150)

            // Clean up after tone completes
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                toneGen.release()
            }, 200L)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
