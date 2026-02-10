import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/knowledge_cards/knowledge_cards_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/models/models.dart';
import 'package:summify/services/demo_knowledge_cards.dart';

class KnowledgeCardsBottomBar extends StatelessWidget {
  final String summaryKey;
  final SummaryData summaryData;

  const KnowledgeCardsBottomBar({
    super.key,
    required this.summaryKey,
    required this.summaryData,
  });

  static const Color _buttonColor = Color.fromRGBO(0, 186, 195, 1);

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        Theme.of(context).brightness == Brightness.dark
            ? const [
                Color.fromRGBO(15, 57, 60, 1),
                Color.fromRGBO(15, 57, 60, 0),
              ]
            : const [
                Color.fromRGBO(223, 252, 252, 1),
                Color.fromRGBO(223, 252, 252, 0),
              ];

    return BlocBuilder<KnowledgeCardsBloc, KnowledgeCardsState>(
      builder: (context, knowledgeCardsState) {
        final cards = knowledgeCardsState.knowledgeCards[summaryKey] ?? [];
        final status =
            knowledgeCardsState.extractionStatuses[summaryKey] ??
                KnowledgeCardStatus.initial;
        final canRegenerate =
            status == KnowledgeCardStatus.complete &&
                summaryKey != DemoKnowledgeCards.demoKey &&
                cards.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.3, 1],
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            left: 15,
            right: 15,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (canRegenerate) _buildRegenerateButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRegenerateButton(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 5, left: 5),
        child: MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 7),
          color: _buttonColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          onPressed: () => _onRegenerateTap(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).knowledgeCards_regenerate,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRegenerateTap(BuildContext context) async {
    if (summaryKey == DemoKnowledgeCards.demoKey) return;
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
    if (confirmed == true && context.mounted) {
      _requestExtractFromSummary(context);
    }
  }

  void _requestExtractFromSummary(BuildContext context) {
    final summaryText = summaryData.longSummary.summaryText ??
        summaryData.shortSummary.summaryText ??
        '';

    if (summaryText.isNotEmpty) {
      context.read<KnowledgeCardsBloc>().add(
        ExtractKnowledgeCards(
          summaryKey: summaryKey,
          summaryText: summaryText,
        ),
      );
    }
  }
}
