import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';

import '../../../bloc/settings/settings_bloc.dart';

class TextSizeModal extends StatelessWidget {
  const TextSizeModal({super.key});

  @override
  Widget build(BuildContext context) {
    void onTapScaleUp() {
      context.read<SettingsBloc>().add(const ScaleUpFontSize());
    }

    void onTapScaleDown() {
      context.read<SettingsBloc>().add(const ScaleDownFontSize());
    }

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Material(
          color: Theme.of(context).canvasColor,
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Text(
                          'Text size',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                    const Padding(
                        padding: EdgeInsets.only(right: 5), child: BackArrow()),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: onTapScaleDown,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                        child: Text(
                          'A',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 26,
                                  ),
                        ),
                      )),
                      Container(
                        width: 1.5,
                        height: 35,
                        color: Theme.of(context).primaryColor,
                      ),
                      Expanded(
                          child: InkWell(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        onTap: onTapScaleUp,
                        child: Text(
                          'A',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 34,
                                  height: 1.5),
                        ),
                      )),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: fontSizes
                      .map((e) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 1, vertical: 5),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: e == state.fontSize
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ))
                      .toList(),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BackArrow extends StatelessWidget {
  final bool? fromOnboarding;
  const BackArrow({super.key, this.fromOnboarding});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      if (fromOnboarding != null) {
        Navigator.of(context).pushNamed('/');
        context.read<MixpanelBloc>().add(const ClosePaywall());
      } else {
        Navigator.of(context).pop();
      }
    }

    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onPressClose,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            minimumSize: MaterialStateProperty.all<Size>(Size(30, 30)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.color!.withOpacity(0))),
        highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.3),
        icon: Icon(
          Icons.close,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ));
  }
}

// class BackArrow extends StatelessWidget {
//   const BackArrow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     void onPressClose() {
//       Navigator.of(context).pop();
//     }

//     return IconButton(
//       visualDensity: VisualDensity.compact,
//       onPressed: onPressClose,
//       //style: ButtonStyle(
//         //padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
//         //backgroundColor: MaterialStatePropertyAll(
//         // Theme.of(context).iconTheme.color!.withOpacity(0.1))),
//       //),
//       highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.2),
//       icon: Container(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: Theme.of(context).iconTheme.color!,
//             width: 1.5,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(4.0), // Adjust the padding as needed
//           child: Icon(
//             Icons.close,
//             size: 20,
//             color: Theme.of(context).iconTheme.color,
//           ),
//         ),
//       ),
//     );
//   }
// }
