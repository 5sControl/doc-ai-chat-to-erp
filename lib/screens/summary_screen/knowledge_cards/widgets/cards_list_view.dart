import 'package:flutter/material.dart';
import 'package:summify/models/models.dart';

import 'knowledge_card_tile.dart';
import 'unsupported_device_placeholder.dart';

class CardsListView extends StatelessWidget {
  final List<KnowledgeCard> cards;
  final KnowledgeCardStatus status;
  final Function(KnowledgeCard) onCardTap;
  final Function(KnowledgeCard) onCardSave;
  final VoidCallback onRetry;

  const CardsListView({
    super.key,
    required this.cards,
    required this.status,
    required this.onCardTap,
    required this.onCardSave,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (status == KnowledgeCardStatus.unsupported) {
      return const UnsupportedDevicePlaceholder();
    }
    
    if (status == KnowledgeCardStatus.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Extracting key knowledge...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (status == KnowledgeCardStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to extract knowledge',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (cards.isEmpty && status == KnowledgeCardStatus.complete) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No knowledge cards found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: KnowledgeCardTile(
            card: card,
            onTap: () => onCardTap(card),
            onSave: () => onCardSave(card),
          ),
        );
      },
    );
  }
}