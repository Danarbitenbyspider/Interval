package com.example.intervals_training

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Setup beep player method channel
        BeepPlayer.setupMethodChannel(flutterEngine.dartExecutor.binaryMessenger)
    }
}
