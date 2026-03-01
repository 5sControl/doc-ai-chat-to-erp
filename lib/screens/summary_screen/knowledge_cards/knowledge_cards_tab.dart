import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/knowledge_cards/knowledge_cards_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/models/models.dart';
import 'package:summify/services/demo_knowledge_cards.dart';

import 'widgets/cards_type_filter.dart';
import 'widgets/cards_list_view.dart';
import 'widgets/card_detail_modal.dart';
import 'widgets/card_voice_answer_modal.dart';

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

  static const double _kCardsFadeHeight = 24;

  static Color _cardsBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color.fromRGBO(15, 57, 60, 1)
        : const Color.fromRGBO(191, 249, 249, 1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MixpanelBloc>().add(KnowledgeCardsTabOpen(summaryKey: widget.summaryKey));
      }
    });
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
    context.read<MixpanelBloc>().add(KnowledgeCardOpen(
          cardId: card.id,
          summaryKey: widget.summaryKey,
        ));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CardDetailModal(card: card),
    );
  }

  void _onCardMicTap(KnowledgeCard card) {
    context.read<MixpanelBloc>().add(KnowledgeCardVoiceCheckOpen(
          cardId: card.id,
          summaryKey: widget.summaryKey,
        ));
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CardVoiceAnswerModal(
          card: card,
          summaryKey: widget.summaryKey,
        ),
        fullscreenDialog: true,
      ),
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

        final bottomInset = 10.0 + MediaQuery.of(context).padding.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            children: [
              // Type filter
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
                ],
              ),

              // Cards list with top/bottom fade
              Expanded(
                child: Stack(
                  children: [
                    CardsListView(
                      cards: filteredCards,
                      status: status,
                      onCardTap: _onCardTap,
                      onCardSave: _onCardSave,
                      onRetry: _extractKnowledgeCards,
                      onCardMicTap: _onCardMicTap,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: _kCardsFadeHeight,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                _cardsBackgroundColor(context),
                                _cardsBackgroundColor(context).withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: _kCardsFadeHeight,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                _cardsBackgroundColor(context),
                                _cardsBackgroundColor(context).withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}