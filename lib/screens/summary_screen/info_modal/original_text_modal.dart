import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../../gen/assets.gen.dart';

class OriginalTextModal extends StatelessWidget {
  final String originalText;

  const OriginalTextModal({super.key, required this.originalText});

  @override
  Widget build(BuildContext context) {
    void onPressCopy() {
      Clipboard.setData(ClipboardData(text: originalText));
      context.read<MixpanelBloc>().add(const CopySummary());
      Navigator.of(context).pop();
    }

    return Material(
      color: Theme.of(context).canvasColor,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20),
                  child: Text(
                    'Original Text',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 5, top: 10),
                  child: BackArrow(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SelectableText(
                  originalText,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: MaterialButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: onPressCopy,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.icons.copy,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Copy Text',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      Navigator.of(context).pop();
    }

    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: onPressClose,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
        minimumSize: MaterialStateProperty.all<Size>(const Size(30, 30)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(
          Theme.of(context).iconTheme.color!.withOpacity(0),
        ),
      ),
      highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.3),
      icon: Icon(
        Icons.close,
        size: 18,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
