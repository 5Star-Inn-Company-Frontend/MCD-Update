package com.example.mcd

import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class MainActivity: FlutterFragmentActivity() {
	private val CHANNEL = "mcd.storage/channel"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			when (call.method) {
				"saveFileToDownloads" -> {
					val sourcePath = call.argument<String>("sourcePath")
					val displayName = call.argument<String>("displayName")
					val mimeType = call.argument<String>("mimeType") ?: "image/png"

					if (sourcePath == null || displayName == null) {
						result.error("INVALID_ARGS", "sourcePath and displayName required", null)
						return@setMethodCallHandler
					}

					try {
						val savedUri = saveFileToDownloads(sourcePath, displayName, mimeType)
						if (savedUri != null) {
							result.success(savedUri.toString())
						} else {
							result.error("SAVE_FAILED", "Could not save file to Downloads", null)
						}
					} catch (e: Exception) {
						result.error("EXCEPTION", e.message, null)
					}
				}
				else -> result.notImplemented()
			}
		}
	}

	private fun saveFileToDownloads(sourcePath: String, displayName: String, mimeType: String): android.net.Uri? {
		val sourceFile = File(sourcePath)
		if (!sourceFile.exists()) return null

		val resolver = applicationContext.contentResolver

		val contentValues = ContentValues().apply {
			put(MediaStore.MediaColumns.DISPLAY_NAME, displayName)
			put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
				put(MediaStore.MediaColumns.RELATIVE_PATH, "Download/")
			}
		}

		val collection = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
			MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
		} else {
			MediaStore.Files.getContentUri("external")
		}

		val uri = resolver.insert(collection, contentValues) ?: return null

		resolver.openOutputStream(uri).use { outStream ->
			FileInputStream(sourceFile).use { inputStream ->
				inputStream.copyTo(outStream!!)
			}
		}

		return uri
	}
}
