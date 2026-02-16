import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/models/models.dart';
import 'package:summify/screens/summary_screen/markdown_word_tap_builder.dart';
import 'package:summify/screens/summary_screen/word_lookup_helper.dart';
import 'package:toastification/toastification.dart';

class CardDetailModal extends StatelessWidget {
  final KnowledgeCard card;

  const CardDetailModal({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type and title
                  Row(
                    children: [
                      _buildTypeChip(card.type),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildMarkdownWithWordTap(
                    context,
                    data: card.content,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                      strong: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      em: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                      code: TextStyle(
                        fontSize: 14,
                        backgroundColor: Colors.grey.shade100,
                        color: Colors.black87,
                        fontFamily: 'monospace',
                      ),
                      h1: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      h2: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      h3: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      listBullet: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  if (card.explanation != null && card.explanation!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Дополнительное объяснение',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildMarkdownWithWordTap(
                            context,
                            data: card.explanation!,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                              strong: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                              em: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade700,
                              ),
                              code: TextStyle(
                                fontSize: 13,
                                backgroundColor: Colors.grey.shade200,
                                color: Colors.grey.shade700,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyToClipboard(context),
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Копировать'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _shareCard(context),
                          icon: const Icon(Icons.share, size: 16),
                          label: const Text('Поделиться'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMarkdownWithWordTap(
    BuildContext context, {
    required String data,
    required MarkdownStyleSheet styleSheet,
  }) {
    final onWordLookup = createWordLookupHandler(context);

    final builders = <String, MarkdownElementBuilder>{
      'p': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
      'h1': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
      'h2': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
      'h3': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
      'h4': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
      'h5': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
      'h6': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
      'li': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
      'blockquote': MarkdownWordTapBuilder(
          onWordTap: (w) {
            final t = w.trim();
            if (t.isNotEmpty) onWordLookup(context, t);
          }),
    };

    return MarkdownBody(
      data: data,
      styleSheet: styleSheet,
      shrinkWrap: true,
      selectable: true,
      builders: builders,
    );
  }

  Widget _buildTypeChip(KnowledgeCardType type) {
    String label;
    IconData iconData;
    Color color;

    switch (type) {
      case KnowledgeCardType.thesis:
        label = 'Тезис';
        iconData = Icons.lightbulb;
        color = Colors.amber;
        break;
      case KnowledgeCardType.term:
        label = 'Термин';
        iconData = Icons.school;
        color = Colors.blue;
        break;
      case KnowledgeCardType.conclusion:
        label = 'Вывод';
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case KnowledgeCardType.insight:
        label = 'Инсайт';
        iconData = Icons.psychology;
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) async {
    final text = '${card.title}\n\n${card.content}${card.explanation != null ? '\n\n${card.explanation}' : ''}';
    await Clipboard.setData(ClipboardData(text: text));

    if (context.mounted) {
      toastification.show(
        context: context,
        title: const Text('Скопировано в буфер обмена'),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }

  void _shareCard(BuildContext context) {
    final text = '${card.title}\n\n${card.content}${card.explanation != null ? '\n\n${card.explanation}' : ''}';
    Share.share(text);
  }
}