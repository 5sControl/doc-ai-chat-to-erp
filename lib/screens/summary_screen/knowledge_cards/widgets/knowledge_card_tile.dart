import 'package:flutter/material.dart';
import 'package:summify/models/models.dart';

class KnowledgeCardTile extends StatelessWidget {
  final KnowledgeCard card;
  final VoidCallback onTap;
  final VoidCallback onSave;
  final VoidCallback? onMicTap;

  const KnowledgeCardTile({
    super.key,
    required this.card,
    required this.onTap,
    required this.onSave,
    this.onMicTap,
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
              // Header with type icon, optional mic, and save button
              Row(
                children: [
                  _buildTypeIcon(card.type),
                  if (onMicTap != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onMicTap,
                      icon: const Icon(Icons.mic_none, size: 20, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
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

              // Title and expand hint (tap opens full card)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.expand_more,
                    size: 22,
                    color: Colors.grey,
                  ),
                ],
              ),

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