import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'markdown_word_tap_builder.dart';

const _blockTags = ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'li', 'blockquote'];

void _collectBlocks(md.Node node, List<({int start, String text})> blocks) {
  if (node is md.Element) {
    if (_blockTags.contains(node.tag)) {
      final text = node.textContent;
      if (text.isNotEmpty) {
        final prevEnd = blocks.isEmpty ? 0 : blocks.last.start + blocks.last.text.length + 1;
        blocks.add((start: prevEnd, text: text));
      }
    }
    if (node.children != null) {
      for (final child in node.children!) {
        _collectBlocks(child, blocks);
      }
    }
  }
}

/// Collects block elements and their start offsets from markdown in display order.
/// Returns (blockStarts, flattenedText) where flattened = block texts joined by newline.
(List<int> blockStarts, String flattenedText) computeBlockOffsets(String markdown) {
  final doc = md.Document();
  final lines = markdown.split('\n');
  final nodes = doc.parseLines(lines);
  final blocks = <({int start, String text})>[];
  for (final node in nodes) {
    _collectBlocks(node, blocks);
  }
  final starts = blocks.map((b) => b.start).toList();
  final flattened =
      blocks.map((b) => b.text).join('\n');
  return (starts, flattened);
}

/// Builder that supports word tap and TTS highlight (read / current word).
class MarkdownTtsHighlightBuilder extends MarkdownElementBuilder {
  MarkdownTtsHighlightBuilder({
    required this.onWordTap,
    required this.blockOffsets,
    required this.readEndIndex,
    required this.currentWordStart,
    required this.currentWordEnd,
  });

  final void Function(String word) onWordTap;
  final List<int> blockOffsets;
  final int readEndIndex;
  final int currentWordStart;
  final int currentWordEnd;

  int _blockIndex = 0;

  @override
  bool isBlockElement() => false;

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
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
    if (_blockTags.contains(tag)) {
      final blockText = element.textContent;
      if (blockText.isEmpty) return null;
      final blockStart = _blockIndex < blockOffsets.length
          ? blockOffsets[_blockIndex]
          : 0;
      _blockIndex++;
      final style = preferredStyle ?? parentStyle ?? const TextStyle();
      return _HighlightableWordTapText(
        text: blockText,
        style: style,
        blockStart: blockStart,
        onWordTap: onWordTap,
        readEndIndex: readEndIndex,
        currentWordStart: currentWordStart,
        currentWordEnd: currentWordEnd,
      );
    }
    return null;
  }
}

class _HighlightableWordTapText extends StatelessWidget {
  const _HighlightableWordTapText({
    required this.text,
    required this.style,
    required this.blockStart,
    required this.onWordTap,
    required this.readEndIndex,
    required this.currentWordStart,
    required this.currentWordEnd,
  });

  final String text;
  final TextStyle style;
  final int blockStart;
  final void Function(String word) onWordTap;
  final int readEndIndex;
  final int currentWordStart;
  final int currentWordEnd;

  @override
  Widget build(BuildContext context) {
    final hasHighlight = readEndIndex > 0 || currentWordEnd > currentWordStart;
    if (!hasHighlight) {
      return _PlainWordTapText(text: text, style: style, onWordTap: onWordTap);
    }
    return _HighlightedWordTapText(
      text: text,
      style: style,
      blockStart: blockStart,
      onWordTap: onWordTap,
      readEndIndex: readEndIndex,
      currentWordStart: currentWordStart,
      currentWordEnd: currentWordEnd,
    );
  }
}

class _PlainWordTapText extends StatefulWidget {
  const _PlainWordTapText({
    required this.text,
    required this.style,
    required this.onWordTap,
  });

  final String text;
  final TextStyle style;
  final void Function(String word) onWordTap;

  @override
  State<_PlainWordTapText> createState() => _PlainWordTapTextState();
}

class _PlainWordTapTextState extends State<_PlainWordTapText> {
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
            final word = _wordAtPosition(
              details.localPosition,
              constraints.maxWidth,
            );
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

class _HighlightedWordTapText extends StatefulWidget {
  const _HighlightedWordTapText({
    required this.text,
    required this.style,
    required this.blockStart,
    required this.onWordTap,
    required this.readEndIndex,
    required this.currentWordStart,
    required this.currentWordEnd,
  });

  final String text;
  final TextStyle style;
  final int blockStart;
  final void Function(String word) onWordTap;
  final int readEndIndex;
  final int currentWordStart;
  final int currentWordEnd;

  @override
  State<_HighlightedWordTapText> createState() => _HighlightedWordTapTextState();
}

class _HighlightedWordTapTextState extends State<_HighlightedWordTapText> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final readColor = (isDark ? Colors.amber : Colors.amber)
        .withValues(alpha: 0.12);
    final currentColor = (isDark ? Colors.amber : Colors.amber)
        .withValues(alpha: 0.35);

    final spans = <TextSpan>[];
    int i = 0;
    while (i < widget.text.length) {
      final (wordStart, wordEnd) = wordBoundariesAtOffset(widget.text, i);
      if (wordStart >= wordEnd) {
        spans.add(TextSpan(text: widget.text[i], style: widget.style));
        i++;
        continue;
      }
      final word = widget.text.substring(wordStart, wordEnd);
      final globalStart = widget.blockStart + wordStart;
      final globalEnd = widget.blockStart + wordEnd;

      Color? backgroundColor;
      if (globalStart < widget.currentWordEnd && globalEnd > widget.currentWordStart) {
        backgroundColor = currentColor;
      } else if (globalEnd <= widget.readEndIndex) {
        backgroundColor = readColor;
      }

      spans.add(
        TextSpan(
          text: word,
          style: widget.style.copyWith(backgroundColor: backgroundColor),
        ),
      );
      i = wordEnd;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            final word = _wordAtPosition(
              details.localPosition,
              constraints.maxWidth,
            );
            if (word.isNotEmpty) widget.onWordTap(word);
          },
          child: SelectableText.rich(
            TextSpan(children: spans, style: widget.style),
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
