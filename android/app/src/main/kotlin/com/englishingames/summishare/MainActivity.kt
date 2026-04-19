package com.englishingames.summishare

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.summify.share"

    /**
     * Pending payload for Flutter [getSharedData]: String (text), Map (single file), or List (mixed / multiple files).
     * Cleared after a successful push via MethodChannel or after Flutter reads it.
     */
    private var pendingSharePayload: Any? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            if (call.method == "getSharedData") {
                val payload = pendingSharePayload
                pendingSharePayload = null
                result.success(payload)
            } else {
                result.notImplemented()
            }
        }

        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        Log.d("Summify", "MainActivity: handleIntent action=${intent?.action} type=${intent?.type} data=${intent?.data}")

        when (intent?.action) {
            Intent.ACTION_VIEW -> handleViewIntent(intent)
            Intent.ACTION_SEND -> {
                if (intent.type?.startsWith("text/") == true) {
                    handleSendText(intent)
                } else {
                    handleSendFile(intent)
                }
            }
            Intent.ACTION_SEND_MULTIPLE -> handleSendMultipleFiles(intent)
        }
    }

    private fun handleViewIntent(intent: Intent) {
        val uri = intent.data ?: return
        // Avoid treating https invite / universal links as local files
        if (uri.scheme.equals("https", ignoreCase = true) ||
            uri.scheme.equals("http", ignoreCase = true)
        ) {
            return
        }
        val path = getRealPathFromURI(uri) ?: return
        val fileData = mapOf(
            "path" to path,
            "type" to 2,
        )
        deliverMediaToFlutter(listOf(fileData))
    }

    private fun handleSendText(intent: Intent) {
        intent.getStringExtra(Intent.EXTRA_TEXT)?.let { text ->
            Log.d("Summify", "Shared text: $text")
            pendingSharePayload = text
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, channelName).invokeMethod("onSharedText", listOf(text))
                pendingSharePayload = null
            }
        }
    }

    private fun handleSendFile(intent: Intent) {
        val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(Intent.EXTRA_STREAM)
        } ?: return

        Log.d("Summify", "Shared file URI: $uri")
        val path = getRealPathFromURI(uri) ?: return
        val fileData = mapOf("path" to path, "type" to 2)
        deliverMediaToFlutter(listOf(fileData))
    }

    private fun handleSendMultipleFiles(intent: Intent) {
        val uris: ArrayList<Uri> = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM)
        } ?: return

        Log.d("Summify", "Shared multiple files: ${uris.size}")
        val files = uris.mapNotNull { uri ->
            getRealPathFromURI(uri)?.let { path ->
                mapOf("path" to path, "type" to 2)
            }
        }
        if (files.isNotEmpty()) {
            deliverMediaToFlutter(files)
        }
    }

    private fun deliverMediaToFlutter(files: List<Map<String, Any>>) {
        pendingSharePayload = if (files.size == 1) files[0] else files
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, channelName).invokeMethod("onSharedMedia", files)
            pendingSharePayload = null
        }
    }

    private fun getRealPathFromURI(uri: Uri): String? {
        return try {
            contentResolver.openInputStream(uri)?.use { inputStream ->
                val fileName = getFileName(uri)
                val file = java.io.File(cacheDir, fileName)
                file.outputStream().use { outputStream ->
                    inputStream.copyTo(outputStream)
                }
                file.absolutePath
            }
        } catch (e: Exception) {
            Log.e("Summify", "Error copying from URI: ${e.message}")
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
