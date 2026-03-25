// String getTransformedText({required String text}) {
//   return text
//       .replaceAll('\n', '')
//       .replaceAll('\n\n', '\n')
//       .replaceAll('\n\n\n', '\n')
//       .replaceAll('.- ', '.\n- ')
//       .replaceFirst('Summary:', '<b>Summary:\n</b>')
//       .replaceFirst('Key Points:', '<b>\n\nKey Points:\n</b>')
//       .replaceFirst('In-depth Analysis:', '<b>\n\nIn-depth Analysis:\n</b>')
//       .replaceFirst('Additional Context:', '<b>\n\nAdditional Context:\n</b>')
//       .replaceFirst('Supporting Evidence:', '<b>\n\nSupporting Evidence:\n</b>')
//       .replaceFirst('Implications or Conclusions:',
//           '<b>\n\nImplications or Conclusions:\n</b>');
// }

/// LLMs often prefix `---### Title`. Putting `---` on its own MD line renders as `<hr>`.
/// Drop the dash run and keep the ATX heading so layout stays clean.
String _dropDecorativeRuleBeforeAtxHeading(String text) {
  return text.replaceAllMapped(
    RegExp(r'-{3,}\s*(#{1,6})'),
    (m) => m[1]!,
  );
}

/// Removes leading lines that are only a thematic break (`---`, `***`, `___`).
String _stripLeadingThematicBreakLines(String text) {
  final lines = text.split('\n');
  var i = 0;
  while (i < lines.length) {
    final line = lines[i];
    if (RegExp(r'^\s*(-{3,}|\*{3,}|_{3,})\s*$').hasMatch(line)) {
      i++;
    } else {
      break;
    }
  }
  if (i == 0) return text;
  return lines.sublist(i).join('\n');
}

/// [getTransformedText] collapses all newlines, so "###" often glues to the prior
/// sentence (e.g. `codebase.###Key Points`). ATX headings must start a line and
/// (per CommonMark) need a space after the hash run before the title text.
String _ensureNewlineBeforeGluedAtxHeading(String text) {
  var s = text.replaceAllMapped(
    RegExp(r'(?<![0-9])\.\s*(#{1,6})(?=[A-Za-zА-Яа-яЁё#])'),
    (m) => '.\n${m[1]}',
  );
  s = s.replaceAllMapped(
    RegExp(r'([!?:)\]])\s*(#{1,6})(?=[A-Za-zА-Яа-яЁё#])'),
    (m) => '${m[1]}\n${m[2]}',
  );
  s = s.replaceAllMapped(
    RegExp(r'([a-zа-яёё])\s*(#{1,6})(?=[A-Za-zА-Яа-яЁё#])'),
    (m) => '${m[1]}\n${m[2]}',
  );
  return s;
}

String _ensureSpaceAfterAtxLineStart(String text) {
  return text.replaceAllMapped(
    RegExp(r'(^|\n)(#{1,6})([A-Za-zА-Яа-яЁё])', multiLine: true),
    (m) => '${m[1]}${m[2]} ${m[3]}',
  );
}

/// Normalizes summary markdown for on-screen rendering (brief/deep/source tabs).
String prepareMarkdownForDisplay(String text) {
  return _stripLeadingThematicBreakLines(
    _ensureSpaceAfterAtxLineStart(
      _ensureNewlineBeforeGluedAtxHeading(
        _dropDecorativeRuleBeforeAtxHeading(text),
      ),
    ),
  );
}

String getTransformedText({required String text}) {
  var s = text.replaceAll('\n', '');
  s = _dropDecorativeRuleBeforeAtxHeading(s);
  s = _ensureNewlineBeforeGluedAtxHeading(s);
  s = s
      .replaceAll('   ', '')
      .replaceAll('\n\n', '\n')
      .replaceAll('\n\n\n', '\n')
      .replaceAll('.- ', '.\n- ')
      .replaceFirst('Summary:', 'Summary:\n')
      .replaceFirst('Key Points:', '\n\nKey Points:\n')
      .replaceFirst('In-depth Analysis:', '\n\nIn-depth Analysis:\n')
      .replaceFirst('Additional Context:', '\n\nAdditional Context:\n')
      .replaceFirst('Supporting Evidence:', '\n\nSupporting Evidence:\n')
      .replaceFirst(
        'Implications or Conclusions:',
        '\n\nImplications or Conclusions:\n',
      );
  s = _ensureSpaceAfterAtxLineStart(s);
  return _stripLeadingThematicBreakLines(s);
}

/// Strips Markdown syntax so TTS does not read "hash hash" or asterisks.
/// Removes ##, ###, ####, **, __, leading --- (leaving the text content).
String stripMarkdownForTts(String text) {
  return text
      .replaceFirst(RegExp(r'^-{2,}\s*'), '')
      .replaceAll(RegExp(r'^#+\s*', multiLine: true), '')
      .replaceAll('**', '')
      .replaceAll('__', '');
}
