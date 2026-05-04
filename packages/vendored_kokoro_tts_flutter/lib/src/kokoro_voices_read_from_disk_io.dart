import 'dart:io' show File;

/// Reads `voices.json` from app storage (e.g. after a path_provider download).
/// Used when the Kokoro `voicesPath` is an absolute filesystem path, not a Flutter asset key.
Future<String> loadKokoroVoicesJsonFromFilesystemPath(String absolutePath) async {
  final file = File(absolutePath);
  if (!await file.exists()) {
    throw Exception('Kokoro voices file not found at path: $absolutePath');
  }
  return file.readAsString();
}
