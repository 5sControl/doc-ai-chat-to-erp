import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Full-screen viewer for a Mermaid diagram. Loads HTML template from assets
/// with Mermaid.js from CDN and renders the [mermaidCode] inside the app.
class MermaidViewerScreen extends StatefulWidget {
  final String mermaidCode;
  final String title;

  const MermaidViewerScreen({
    super.key,
    required this.mermaidCode,
    this.title = 'Diagram',
  });

  @override
  State<MermaidViewerScreen> createState() => _MermaidViewerScreenState();
}

const _templatePath = 'assets/html/mermaid_viewer.html';
const _placeholder = '{{MERMAID_CODE}}';

class _MermaidViewerScreenState extends State<MermaidViewerScreen> {
  late final WebViewController _controller;
  bool _loaded = false;
  String? _error;

  static String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }

  Future<String> _loadHtml() async {
    final template = await rootBundle.loadString(_templatePath);
    final escaped = _escapeHtml(widget.mermaidCode);
    return template.replaceAll(_placeholder, escaped);
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loaded = true);
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() => _error = error.description);
            }
          },
        ),
      );

    _loadHtml().then((html) {
      if (!mounted) return;
      _controller.loadHtmlString(
        html,
        baseUrl: 'https://cdn.jsdelivr.net/',
      );
    }).catchError((e, st) {
      if (mounted) setState(() => _error = e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey.shade600),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (!_loaded)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
