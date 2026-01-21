import 'package:flutter/material.dart';
import 'package:summify/models/models.dart';

class SavedCardTile extends StatelessWidget {
  final KnowledgeCard card;
  final VoidCallback onTap;
  final VoidCallback onSave;
  final VoidCallback? onSourceTap;

  const SavedCardTile({
    super.key,
    required this.card,
    required this.onTap,
    required this.onSave,
    this.onSourceTap,
  });

  IconData _getCardIcon() {
    switch (card.type) {
      case KnowledgeCardType.thesis:
        return Icons.lightbulb_outline;
      case KnowledgeCardType.term:
        return Icons.article_outlined;
      case KnowledgeCardType.conclusion:
        return Icons.check_circle_outline;
      case KnowledgeCardType.insight:
        return Icons.auto_awesome_outlined;
    }
  }

  Color _getCardColor() {
    switch (card.type) {
      case KnowledgeCardType.thesis:
        return const Color(0xFFFFF9C4); // Light yellow
      case KnowledgeCardType.term:
        return const Color(0xFFE1F5FE); // Light blue
      case KnowledgeCardType.conclusion:
        return const Color(0xFFC8E6C9); // Light green
      case KnowledgeCardType.insight:
        return const Color(0xFFF3E5F5); // Light purple
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and bookmark
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCardColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCardIcon(),
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Bookmark icon
                  IconButton(
                    onPressed: onSave,
                    icon: Icon(
                      card.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: const Color.fromRGBO(0, 186, 195, 1),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Content
              Text(
                card.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Source link at bottom left
              if (card.sourceTitle != null) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: onSourceTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 16,
                        color: const Color.fromRGBO(0, 186, 195, 1),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          card.sourceTitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(0, 186, 195, 1),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color.fromRGBO(0, 186, 195, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
