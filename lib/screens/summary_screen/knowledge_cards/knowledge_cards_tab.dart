import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/knowledge_cards/knowledge_cards_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/models/models.dart';
import 'package:summify/services/demo_knowledge_cards.dart';

import 'widgets/cards_type_filter.dart';
import 'widgets/cards_list_view.dart';
import 'widgets/card_detail_modal.dart';

class KnowledgeCardsTab extends StatefulWidget {
  final String summaryKey;

  const KnowledgeCardsTab({
    super.key,
    required this.summaryKey,
  });

  @override
  State<KnowledgeCardsTab> createState() => _KnowledgeCardsTabState();
}

class _KnowledgeCardsTabState extends State<KnowledgeCardsTab> {
  KnowledgeCardType? _selectedType;

  @override
  void initState() {
    super.initState();
    // Extract knowledge cards when tab is first opened
    _extractKnowledgeCards();
    // Sync with saved cards
    _syncWithSavedCards();
  }

  void _syncWithSavedCards() {
    // Check if cards already exist for this summary
    final knowledgeCardsState = context.read<KnowledgeCardsBloc>().state;
    final hasCards = knowledgeCardsState.knowledgeCards[widget.summaryKey]?.isNotEmpty ?? false;
    
    if (hasCards) {
      // Sync saved status with SavedCardsBloc
      context.read<KnowledgeCardsBloc>().add(
        SyncCardsWithSaved(summaryKey: widget.summaryKey),
      );
    }
  }

  void _extractKnowledgeCards() {
    // Check if cards already exist
    final knowledgeCardsState = context.read<KnowledgeCardsBloc>().state;
    final existingCards = knowledgeCardsState.knowledgeCards[widget.summaryKey];
    final status = knowledgeCardsState.extractionStatuses[widget.summaryKey];

    // Don't re-extract if cards already exist and are complete
    if (existingCards != null &&
        existingCards.isNotEmpty &&
        status == KnowledgeCardStatus.complete) {
      return;
    }

    // Check if this is demo summary - initialize demo cards instead
    if (widget.summaryKey == DemoKnowledgeCards.demoKey) {
      context.read<KnowledgeCardsBloc>().add(
        const InitializeDemoCards(),
      );
      return;
    }

    _requestExtractFromSummary();
  }

  /// Shows confirm dialog and requests card extraction (regenerate) if user confirms.
  Future<void> _onRegenerateTap() async {
    if (widget.summaryKey == DemoKnowledgeCards.demoKey) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.knowledgeCards_regenerateTitle),
        content: Text(l10n.knowledgeCards_regenerateMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.knowledgeCards_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.knowledgeCards_regenerate),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      _regenerateKnowledgeCards();
    }
  }

  /// Requests card extraction from current summary text (used after dialog confirm).
  void _regenerateKnowledgeCards() {
    if (widget.summaryKey == DemoKnowledgeCards.demoKey) return;
    _requestExtractFromSummary();
  }

  void _requestExtractFromSummary() {
    final summariesState = context.read<SummariesBloc>().state;
    final summaryData = summariesState.summaries[widget.summaryKey];

    if (summaryData != null) {
      final summaryText = summaryData.longSummary.summaryText ??
          summaryData.shortSummary.summaryText ??
          '';

      if (summaryText.isNotEmpty) {
        context.read<KnowledgeCardsBloc>().add(
          ExtractKnowledgeCards(
            summaryKey: widget.summaryKey,
            summaryText: summaryText,
          ),
        );
      }
    }
  }

  void _onCardTap(KnowledgeCard card) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CardDetailModal(card: card),
    );
  }

  void _onCardSave(KnowledgeCard card) {
    if (card.isSaved) {
      context.read<KnowledgeCardsBloc>().add(
        UnsaveKnowledgeCard(
          summaryKey: widget.summaryKey,
          cardId: card.id,
        ),
      );
    } else {
      // Get source title from summary preview
      final summariesState = context.read<SummariesBloc>().state;
      final summaryData = summariesState.summaries[widget.summaryKey];
      final sourceTitle = summaryData?.summaryPreview.title ?? widget.summaryKey;
      
      context.read<KnowledgeCardsBloc>().add(
        SaveKnowledgeCard(
          summaryKey: widget.summaryKey,
          cardId: card.id,
          sourceTitle: sourceTitle,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KnowledgeCardsBloc, KnowledgeCardsState>(
      builder: (context, knowledgeCardsState) {
        final cards = knowledgeCardsState.knowledgeCards[widget.summaryKey] ?? [];
        final filteredCards = _selectedType != null
            ? cards.where((card) => card.type == _selectedType).toList()
            : cards;

        final status = knowledgeCardsState.extractionStatuses[widget.summaryKey] ?? KnowledgeCardStatus.initial;

        // Sync with saved cards on every rebuild (when user returns to tab)
        if (cards.isNotEmpty && status == KnowledgeCardStatus.complete) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<KnowledgeCardsBloc>().add(
              SyncCardsWithSaved(summaryKey: widget.summaryKey),
            );
          });
        }

        final canRegenerate = status == KnowledgeCardStatus.complete &&
            widget.summaryKey != DemoKnowledgeCards.demoKey &&
            cards.isNotEmpty;

        return Column(
          children: [
            // Type filter and Regenerate
            Row(
              children: [
                Expanded(
                  child: CardsTypeFilter(
                    selectedType: _selectedType,
                    onTypeSelected: (type) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                  ),
                ),
                if (canRegenerate)
                  TextButton.icon(
                    onPressed: _onRegenerateTap,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(AppLocalizations.of(context).knowledgeCards_regenerate),
                  ),
              ],
            ),

            // Cards list
            Expanded(
              child: CardsListView(
                cards: filteredCards,
                status: status,
                onCardTap: _onCardTap,
                onCardSave: _onCardSave,
                onRetry: _extractKnowledgeCards,
              ),
            ),
          ],
        );
      },
    );
  }
}