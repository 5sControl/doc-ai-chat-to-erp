import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';

Future<void> showRedeemGiftCodeDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    builder: (context) => const RedeemGiftCodeDialog(),
  );
}

class RedeemGiftCodeDialog extends StatefulWidget {
  const RedeemGiftCodeDialog({super.key});

  @override
  State<RedeemGiftCodeDialog> createState() => _RedeemGiftCodeDialogState();
}

class _RedeemGiftCodeDialogState extends State<RedeemGiftCodeDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<SummariesBloc, SummariesState>(
      listener: (context, state) {
        if (state.lastRedeemMessage == null) return;
        final wasSuccess = state.lastRedeemMessage == 'success';
        final message = wasSuccess
            ? l10n.giftCode_success(giftCreditsPerCode)
            : l10n.giftCode_error;
        context.read<SummariesBloc>().add(const ClearRedeemMessage());
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        if (wasSuccess) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text(l10n.giftCode_dialogTitle),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.giftCode_placeholder,
              hintText: l10n.giftCode_placeholder,
            ),
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () {
                final code = _controller.text.trim();
                if (code.isEmpty) return;
                context.read<SummariesBloc>().add(RedeemGiftCode(code: code));
              },
              child: Text(l10n.giftCode_activate),
            ),
          ],
        );
      },
    );
  }
}
