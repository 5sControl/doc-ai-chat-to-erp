import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:summify/models/models.dart';

class KnowledgeCardTile extends StatelessWidget {
  final KnowledgeCard card;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const KnowledgeCardTile({
    super.key,
    required this.card,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type icon and save button
              Row(
                children: [
                  _buildTypeIcon(card.type),
                  const Spacer(),
                  IconButton(
                    onPressed: onSave,
                    icon: Icon(
                      card.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: card.isSaved ? Theme.of(context).primaryColor : Colors.grey,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Title
              Text(
                card.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Content preview
              MarkdownBody(
                data: card.content,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  strong: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  em: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                  code: TextStyle(
                    fontSize: 13,
                    backgroundColor: Colors.grey.shade100,
                    color: Colors.black87,
                    fontFamily: 'monospace',
                  ),
                ),
                shrinkWrap: true,
              ),

              if (card.explanation != null && card.explanation!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: MarkdownBody(
                    data: card.explanation!,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      strong: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                      em: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                      code: TextStyle(
                        fontSize: 11,
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.grey.shade700,
                        fontFamily: 'monospace',
                      ),
                    ),
                    shrinkWrap: true,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(KnowledgeCardType type) {
    IconData iconData;
    Color color;

    switch (type) {
      case KnowledgeCardType.thesis:
        iconData = Icons.lightbulb;
        color = Colors.amber;
        break;
      case KnowledgeCardType.term:
        iconData = Icons.school;
        color = Colors.blue;
        break;
      case KnowledgeCardType.conclusion:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case KnowledgeCardType.insight:
        iconData = Icons.psychology;
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        size: 16,
        color: color,
      ),
    );
  }
}