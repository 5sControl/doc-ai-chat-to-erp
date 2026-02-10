import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// Extracts the word at [offset] in [text] (word boundaries by spaces/punctuation).
String wordAtOffset(String text, int offset) {
  if (text.isEmpty || offset < 0 || offset >= text.length) return '';
  int start = offset;
  int end = offset;
  while (start > 0 && _isWordChar(text, start - 1)) {
    start--;
  }
  while (end < text.length && _isWordChar(text, end)) {
    end++;
  }
  return start < end ? text.substring(start, end) : '';
}

/// Returns (start, end) character indices for the word at [offset].
/// If offset is not inside a word, returns (offset, offset).
(int, int) wordBoundariesAtOffset(String text, int offset) {
  if (text.isEmpty || offset < 0 || offset >= text.length) {
    return (0, 0);
  }
  int start = offset;
  int end = offset;
  while (start > 0 && _isWordChar(text, start - 1)) {
    start--;
  }
  while (end < text.length && _isWordChar(text, end)) {
    end++;
  }
  return (start, end);
}

bool _isWordChar(String s, int i) {
  if (i < 0 || i >= s.length) return false;
  final c = s.codeUnitAt(i);
  return (c >= 0x30 && c <= 0x39) || // 0-9
      (c >= 0x41 && c <= 0x5A) || // A-Z
      (c >= 0x61 && c <= 0x7A) || // a-z
      (c >= 0xC0); // extended letters (e.g. accented, Cyrillic)
}

/// Markdown element builder for block text (p, h1..h6) that detects tap and reports the tapped word.
class MarkdownWordTapBuilder extends MarkdownElementBuilder {
  MarkdownWordTapBuilder({required this.onWordTap});

  final void Function(String word) onWordTap;

  @override
  bool isBlockElement() => false;

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    // Return a placeholder so the builder still adds to _inlines and flushes correctly.
    // Our visitElementAfterWithContext will replace the whole block with the tappable widget.
    return const SizedBox.shrink();
  }

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final tag = element.tag;
    if (tag == 'p' ||
        tag == 'h1' ||
        tag == 'h2' ||
        tag == 'h3' ||
        tag == 'h4' ||
        tag == 'h5' ||
        tag == 'h6' ||
        tag == 'li' ||
        tag == 'blockquote') {
      final text = element.textContent;
      if (text.isEmpty) return null;
      final style = preferredStyle ?? parentStyle ?? const TextStyle();
      return _WordTapText(
        text: text,
        style: style,
        onWordTap: onWordTap,
      );
    }
    return null;
  }
}

class _WordTapText extends StatefulWidget {
  const _WordTapText({
    required this.text,
    required this.style,
    required this.onWordTap,
  });

  final String text;
  final TextStyle style;
  final void Function(String word) onWordTap;

  @override
  State<_WordTapText> createState() => _WordTapTextState();
}

class _WordTapTextState extends State<_WordTapText> {
  static const _selectionDebounceMs = 450;
  Timer? _selectionDebounceTimer;
  TextSelection? _lastSelection;

  void _onSelectionChanged(TextSelection selection, SelectionChangedCause? cause) {
    if (selection.start == selection.end) return;
    if (selection.end > widget.text.length) return;
    _lastSelection = selection;
    _selectionDebounceTimer?.cancel();
    _selectionDebounceTimer = Timer(
      const Duration(milliseconds: _selectionDebounceMs),
      () {
        if (!mounted) return;
        final sel = _lastSelection;
        if (sel == null || sel.start == sel.end || sel.end > widget.text.length) {
          return;
        }
        var selectedText = widget.text.substring(sel.start, sel.end).trim();
        if (selectedText.length > 500) selectedText = selectedText.substring(0, 500);
        if (selectedText.length >= 2) {
          widget.onWordTap(selectedText);
        }
      },
    );
  }

  @override
  void dispose() {
    _selectionDebounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            final word = _wordAtPosition(details.localPosition, constraints.maxWidth);
            if (word.isNotEmpty) widget.onWordTap(word);
          },
          child: SelectableText.rich(
            TextSpan(text: widget.text, style: widget.style),
            textAlign: TextAlign.start,
            onSelectionChanged: _onSelectionChanged,
          ),
        );
      },
    );
  }

  String _wordAtPosition(Offset localPosition, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    final position = painter.getPositionForOffset(localPosition);
    return wordAtOffset(widget.text, position.offset);
  }
}
