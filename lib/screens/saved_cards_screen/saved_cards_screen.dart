import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/saved_cards/saved_cards_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/models/models.dart';
import 'package:summify/screens/saved_cards_screen/saved_card_tile.dart';
import 'package:summify/screens/summary_screen/knowledge_cards/widgets/cards_type_filter.dart';
import 'package:summify/screens/summary_screen/knowledge_cards/widgets/card_detail_modal.dart';
import 'package:summify/screens/summary_screen/summary_screen.dart';

class SavedCardsScreen extends StatefulWidget {
  const SavedCardsScreen({super.key});

  @override
  State<SavedCardsScreen> createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends State<SavedCardsScreen> {
  final TextEditingController _searchController = TextEditingController();
  KnowledgeCardType? _selectedType;
  String _searchQuery = '';
  bool _screenOpenTracked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_screenOpenTracked) {
        _screenOpenTracked = true;
        context.read<MixpanelBloc>().add(const SavedCardsScreenOpen());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCardTap(KnowledgeCard card) {
    context.read<MixpanelBloc>().add(SavedCardView(
          cardId: card.id,
          summaryKey: card.sourceSummaryKey,
        ));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CardDetailModal(card: card),
    );
  }

  void _onCardRemove(KnowledgeCard card) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.savedCards_removeBookmarkTitle),
        content: Text(
          AppLocalizations.of(context)!.savedCards_removeBookmarkMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.savedCards_cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<MixpanelBloc>().add(SavedCardRemoved(
                    cardId: card.id,
                    summaryKey: card.sourceSummaryKey,
                  ));
              context.read<SavedCardsBloc>().add(RemoveSavedCard(cardId: card.id));
              Navigator.pop(dialogContext);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.savedCards_cardRemoved),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(AppLocalizations.of(context)!.savedCards_remove),
          ),
        ],
      ),
    );
  }

  void _onSourceTap(KnowledgeCard card) {
    if (card.sourceSummaryKey == null) return;

    // Check if summary exists
    final summariesState = context.read<SummariesBloc>().state;
    final summaryData = summariesState.summaries[card.sourceSummaryKey];

    if (summaryData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryScreen(
            summaryKey: card.sourceSummaryKey!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.savedCards_sourceNotFound),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  List<KnowledgeCard> _filterCards(List<KnowledgeCard> cards) {
    var filtered = cards;

    // Filter by type
    if (_selectedType != null) {
      filtered = filtered.where((card) => card.type == _selectedType).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((card) {
        return card.title.toLowerCase().contains(query) ||
               card.content.toLowerCase().contains(query) ||
               (card.sourceTitle?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.savedCards_title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        actions: [
          BlocBuilder<SavedCardsBloc, SavedCardsState>(
            builder: (context, state) {
              if (state.count == 0) return const SizedBox.shrink();
              
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  _showClearAllDialog();
                },
                tooltip: AppLocalizations.of(context)!.savedCards_clearAll,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SavedCardsBloc, SavedCardsState>(
        builder: (context, state) {
          if (state.count == 0) {
            return _buildEmptyState();
          }

          final allCards = state.allCardsSorted;
          final filteredCards = _filterCards(allCards);

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.savedCards_searchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              // Type filter
              CardsTypeFilter(
                selectedType: _selectedType,
                onTypeSelected: (type) {
                  setState(() {
                    _selectedType = type;
                  });
                },
              ),

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      filteredCards.length == 1 
                        ? AppLocalizations.of(context)!.savedCards_cardCount(filteredCards.length)
                        : AppLocalizations.of(context)!.savedCards_cardsCount(filteredCards.length),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (_searchQuery.isNotEmpty || _selectedType != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _selectedType = null;
                            _searchController.clear();
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.savedCards_clearFilters),
                      ),
                  ],
                ),
              ),

              // Cards list
              Expanded(
                child: filteredCards.isEmpty
                    ? _buildNoResultsState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredCards.length,
                        itemBuilder: (context, index) {
                          final card = filteredCards[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SavedCardTile(
                              card: card,
                              onTap: () => _onCardTap(card),
                              onSave: () => _onCardRemove(card),
                              onSourceTap: () => _onSourceTap(card),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.savedCards_noCardsYet,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.savedCards_saveCardsToAccess,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.savedCards_noCardsFound,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.savedCards_tryAdjustingFilters,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.savedCards_clearAllTitle),
        content: Text(
          AppLocalizations.of(context)!.savedCards_clearAllMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.savedCards_cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<SavedCardsBloc>().add(const ClearAllSavedCards());
              Navigator.pop(dialogContext);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.savedCards_allCleared),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(AppLocalizations.of(context)!.savedCards_clearAll),
          ),
        ],
      ),
    );
  }
}
