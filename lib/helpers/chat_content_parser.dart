// Parses chat answer content into text and mermaid diagram segments.
// Used to show "Open diagram" links for ```mermaid ... ``` blocks instead of raw code.

sealed class ChatSegment {
  const ChatSegment();
}

class TextSegment extends ChatSegment {
  final String markdown;
  const TextSegment(this.markdown);
}

class MermaidSegment extends ChatSegment {
  final String code;
  const MermaidSegment(this.code);
}

/// Matches ```mermaid (optional whitespace, newline) then content until closing ```
/// Uses non-greedy match so multiple blocks work.
final RegExp _mermaidBlockPattern = RegExp(
  r'```mermaid\s*\n([\s\S]*?)```',
  multiLine: true,
  dotAll: true,
);

/// Splits [answer] into a list of [TextSegment] and [MermaidSegment] in order.
/// If no mermaid blocks are found, returns a single [TextSegment] with the full text.
List<ChatSegment> parseChatContent(String answer) {
  if (answer.isEmpty) return [const TextSegment('')];

  final segments = <ChatSegment>[];
  int lastEnd = 0;

  for (final match in _mermaidBlockPattern.allMatches(answer)) {
    final textBefore = answer.substring(lastEnd, match.start);
    if (textBefore.isNotEmpty) {
      segments.add(TextSegment(textBefore));
    }
    segments.add(MermaidSegment(match.group(1)!.trim()));
    lastEnd = match.end;
  }

  if (lastEnd < answer.length) {
    segments.add(TextSegment(answer.substring(lastEnd)));
  }

  if (segments.isEmpty) {
    return [TextSegment(answer)];
  }

  return segments;
}

/// Returns true if [segments] contains at least one [MermaidSegment].
bool hasMermaidSegments(List<ChatSegment> segments) {
  return segments.any((s) => s is MermaidSegment);
}
