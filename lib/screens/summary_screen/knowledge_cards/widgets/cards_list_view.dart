import 'package:flutter/material.dart';
import 'package:summify/models/models.dart';

import 'knowledge_card_tile.dart';
import 'knowledge_cards_unavailable_dialog.dart';

class CardsListView extends StatefulWidget {
  const CardsListView({
    super.key,
    required this.cards,
    required this.status,
    required this.onCardTap,
    required this.onCardSave,
    required this.onRetry,
  });

  final List<KnowledgeCard> cards;
  final KnowledgeCardStatus status;
  final Function(KnowledgeCard) onCardTap;
  final Function(KnowledgeCard) onCardSave;
  final VoidCallback onRetry;

  @override
  State<CardsListView> createState() => _CardsListViewState();
}

class _CardsListViewState extends State<CardsListView> {
  bool _errorDialogShown = false;

  @override
  void didUpdateWidget(covariant CardsListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status && widget.status != KnowledgeCardStatus.error) {
      _errorDialogShown = false;
    }
  }

  void _showUnavailableDialogOnce() {
    if (widget.status != KnowledgeCardStatus.error || _errorDialogShown) return;
    _errorDialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      KnowledgeCardsUnavailableDialog.show(context, widget.onRetry);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (status == KnowledgeCardStatus.unsupported || status == KnowledgeCardStatus.error) {
      if (status == KnowledgeCardStatus.error) {
        _showUnavailableDialogOnce();
      }
      return _buildErrorView();
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

  KnowledgeCardStatus get status => widget.status;
  List<KnowledgeCard> get cards => widget.cards;
  VoidCallback get onRetry => widget.onRetry;
  Function(KnowledgeCard) get onCardTap => widget.onCardTap;
  Function(KnowledgeCard) get onCardSave => widget.onCardSave;

  Widget _buildErrorView() {
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
}
