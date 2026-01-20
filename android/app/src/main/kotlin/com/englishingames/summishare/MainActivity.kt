package com.englishingames.summishare

import android.content.Intent
import android.net.Uri
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.summify.share"
    private var sharedData: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSharedData") {
                result.success(sharedData)
                sharedData = null // Clear after reading
            } else {
                result.notImplemented()
            }
        }

        // Handle initial share intent
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        Log.d("Summify", "🔥 MainActivity: handleIntent called")
        Log.d("Summify", "🔥 Intent action: ${intent?.action}")
        Log.d("Summify", "🔥 Intent type: ${intent?.type}")

        when (intent?.action) {
            Intent.ACTION_SEND -> {
                if (intent.type?.startsWith("text/") == true) {
                    handleSendText(intent)
                } else {
                    handleSendFile(intent)
                }
            }
            Intent.ACTION_SEND_MULTIPLE -> {
                handleSendMultipleFiles(intent)
            }
        }
    }

    private fun handleSendText(intent: Intent) {
        intent.getStringExtra(Intent.EXTRA_TEXT)?.let { text ->
            Log.d("Summify", "🔥 Shared text: $text")
            sharedData = text
            
            // Send to Flutter immediately if engine is ready
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("onSharedText", listOf(text))
            }
        }
    }

    private fun handleSendFile(intent: Intent) {
        (intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM))?.let { uri ->
            Log.d("Summify", "🔥 Shared file URI: $uri")
            
            val path = getRealPathFromURI(uri)
            if (path != null) {
                val fileData = mapOf(
                    "path" to path,
                    "type" to 2 // file type
                )
                
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    MethodChannel(messenger, CHANNEL).invokeMethod("onSharedMedia", listOf(fileData))
                }
            }
        }
    }

    private fun handleSendMultipleFiles(intent: Intent) {
        intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)?.let { uris ->
            Log.d("Summify", "🔥 Shared multiple files: ${uris.size}")
            
            val files = uris.mapNotNull { uri ->
                getRealPathFromURI(uri)?.let { path ->
                    mapOf(
                        "path" to path,
                        "type" to 2
                    )
                }
            }
            
            if (files.isNotEmpty()) {
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    MethodChannel(messenger, CHANNEL).invokeMethod("onSharedMedia", files)
                }
            }
        }
    }

    private fun getRealPathFromURI(uri: Uri): String? {
        return try {
            contentResolver.openInputStream(uri)?.use { inputStream ->
                // For content:// URIs, copy to app's cache directory
                val fileName = getFileName(uri)
                val file = java.io.File(cacheDir, fileName)
                file.outputStream().use { outputStream ->
                    inputStream.copyTo(outputStream)
                }
                file.absolutePath
            }
        } catch (e: Exception) {
            Log.e("Summify", "🔥 Error getting file path: ${e.message}")
            null
        }
    }

    private fun getFileName(uri: Uri): String {
        var result: String? = null
        if (uri.scheme == "content") {
            val cursor = contentResolver.query(uri, null, null, null, null)
            cursor?.use {
                if (it.moveToFirst()) {
                    val columnIndex = it.getColumnIndex(android.provider.OpenableColumns.DISPLAY_NAME)
                    if (columnIndex >= 0) {
                        result = it.getString(columnIndex)
                    }
                }
            }
        }
        if (result == null) {
            result = uri.path
            val cut = result?.lastIndexOf('/')
            if (cut != null && cut != -1) {
                result = result?.substring(cut + 1)
            }
        }
        return result ?: "shared_file"
    }
}
