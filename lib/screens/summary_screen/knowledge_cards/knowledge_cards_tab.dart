import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/knowledge_cards/knowledge_cards_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/models/models.dart';

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
  }

  void _extractKnowledgeCards() {
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
      context.read<KnowledgeCardsBloc>().add(
        SaveKnowledgeCard(
          summaryKey: widget.summaryKey,
          cardId: card.id,
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

        return Column(
          children: [
            // Type filter
            CardsTypeFilter(
              selectedType: _selectedType,
              onTypeSelected: (type) {
                setState(() {
                  _selectedType = type;
                });
              },
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