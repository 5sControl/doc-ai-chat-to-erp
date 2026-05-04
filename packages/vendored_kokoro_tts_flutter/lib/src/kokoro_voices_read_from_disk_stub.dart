/// Web / non-IO: Kokoro in Summify only uses bundle assets or mobile downloads.
Future<String> loadKokoroVoicesJsonFromFilesystemPath(String absolutePath) async {
  throw UnsupportedError(
    'Kokoro filesystem voices are not supported on this platform (path was: $absolutePath). '
    'Use an asset key such as assets/…/voices.json.',
  );
}
