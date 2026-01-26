import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/bloc/translates/translates_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/helpers/language_codes.dart';
import 'package:summify/services/summaryApi.dart';
import 'package:summify/services/tts_service.dart';
import 'package:summify/l10n/app_localizations.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../models/models.dart';

class ShareAndCopyButton extends StatefulWidget {
  final int activeTab;
  final SummaryData summaryData;
  final String sharedLink;
  const ShareAndCopyButton({
    super.key,
    required this.summaryData,
    required this.sharedLink,
    required this.activeTab,
  });

  @override
  State<ShareAndCopyButton> createState() => _ShareAndCopyButtonState();
}

class _ShareAndCopyButtonState extends State<ShareAndCopyButton> {
  @override
  Widget build(BuildContext context) {
    void onPressShare() {
      final text =
          widget.activeTab == 0
              ? widget.summaryData.userText
              : widget.activeTab == 1
              ? widget.summaryData.shortSummary.summaryText
              : widget.summaryData.longSummary.summaryText;

      final box = context.findRenderObject() as RenderBox?;
      Share.share(
        '${widget.sharedLink} \n\n $text',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      context.read<MixpanelBloc>().add(const ShareSummary());
    }

    void onPressCopy() {
      final text =
          widget.activeTab == 0
              ? widget.summaryData.userText
              : widget.activeTab == 1
              ? widget.summaryData.shortSummary.summaryText
              : widget.summaryData.longSummary.summaryText;

      Clipboard.setData(ClipboardData(text: text ?? ''));
      context.read<MixpanelBloc>().add(const CopySummary());
    }

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          VoiceButton(
            activeTab: widget.activeTab,
            summaryKey: widget.sharedLink,
            summaryData: widget.summaryData,
          ),
          TranslateButton(
            summaryKey: widget.sharedLink,
            activeTab: widget.activeTab,
            summaryData: widget.summaryData,
          ),
          _buildActionButton(icon: Assets.icons.copy, action: onPressCopy),
          _buildActionButton(icon: Assets.icons.share, action: onPressShare),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback action,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 5, left: 5),
        child: MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 7),
          color: const Color.fromRGBO(0, 186, 195, 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          onPressed: action,
          child: SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class VoiceButton extends StatefulWidget {
  final int activeTab;
  final SummaryData summaryData;
  final String summaryKey;

  const VoiceButton({
    super.key,
    required this.activeTab,
    required this.summaryData,
    required this.summaryKey,
  });

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  String? get _currentText {
    return widget.activeTab == 0
        ? widget.summaryData.userText
        : widget.activeTab == 1
        ? widget.summaryData.shortSummary.summaryText
        : widget.summaryData.longSummary.summaryText;
  }

  bool _modelReadyInfoShown = false;

  Future<void> _showModelReadyInfo(BuildContext context) async {
    if (_modelReadyInfoShown) return;
    final localizations = AppLocalizations.of(context);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations?.ttsModelReadyTitle ?? 'Voice model ready'),
          content: Text(
            localizations?.ttsModelReadyMessage ??
                'Voice model downloaded successfully. You can choose a voice in Settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );
    _modelReadyInfoShown = true;
  }

  Future<void> _handleVoicePlay(BuildContext context) async {
    final text = _currentText;
    if (text == null || text.trim().isEmpty) {
      return;
    }

    final service = TtsService.instance;
    final settings = context.read<SettingsBloc>().state;
    final messenger = ScaffoldMessenger.of(context);
    if (!service.isModelReady) {
      final ready = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => TtsDownloadDialog(service: service),
      );
      if (ready != true) return;
      await _showModelReadyInfo(context);
    }

    try {
      await service.speak(
        text: text,
        voiceId: settings.kokoroVoiceId,
        speed: settings.kokoroSynthesisSpeed,
      );
      
      // Check if text was truncated and show message
      final truncationMessage = service.textTruncationMessage.value;
      if (truncationMessage != null && mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(truncationMessage),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      
      // Ensure service state is reset even if error occurs
      if (service.isSpeaking.value) {
        await service.stop();
      }
      final errorMessage = error.toString().contains('us_gold.json') ||
              error.toString().contains('Unable to load asset')
          ? 'Voice synthesis requires additional files. Please restart the app.'
          : 'Unable to play voice on this device.';
      messenger.showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = TtsService.instance;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 5, left: 5),
        child: ValueListenableBuilder<double>(
          valueListenable: service.downloadProgress,
          builder: (context, _, __) {
            final isDownloading = service.isDownloading;
            return ValueListenableBuilder<bool>(
              valueListenable: service.isSpeaking,
              builder: (context, isSpeaking, __) {
                return MaterialButton(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  color: const Color.fromRGBO(0, 186, 195, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  onPressed:
                      isDownloading
                          ? null
                          : () async {
                            if (isSpeaking) {
                              await service.stop();
                            } else {
                              await _handleVoicePlay(context);
                            }
                          },
                  child:
                      isDownloading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : Icon(
                            isSpeaking ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 26,
                          ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TtsDownloadDialog extends StatefulWidget {
  final TtsService service;

  const TtsDownloadDialog({super.key, required this.service});

  @override
  State<TtsDownloadDialog> createState() => _TtsDownloadDialogState();
}

class _TtsDownloadDialogState extends State<TtsDownloadDialog> {
  @override
  void initState() {
    super.initState();
    widget.service
        .ensureModelReady()
        .then((_) {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        })
        .catchError((error) {
          if (mounted) {
            Navigator.of(context).pop(false);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text(
          localizations?.ttsDownloadDialogTitle ?? 'Downloading voice model',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations?.ttsDownloadDialogBody ??
                  'Please keep the app open while we download the voice resources.',
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<double>(
              valueListenable: widget.service.downloadProgress,
              builder: (context, progress, child) {
                return LinearProgressIndicator(value: progress.clamp(0, 1));
              },
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: widget.service.downloadProgress,
              builder: (context, child) {
                final percent = (widget.service.downloadProgress.value * 100)
                    .clamp(0, 100);
                return Text('${percent.toStringAsFixed(0)}%');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TranslateButton extends StatelessWidget {
  final String summaryKey;
  final int activeTab;
  final SummaryData summaryData;

  const TranslateButton({
    super.key,
    required this.summaryKey,
    required this.activeTab,
    required this.summaryData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (settingsState.translateLanguage == 'en' || activeTab == 0) {
          return const SizedBox();
        }

        return BlocBuilder<TranslatesBloc, TranslatesState>(
          builder: (context, translatesState) {
            final bool isShort = activeTab == 1;
            final bool isLoading =
                translatesState.shortTranslates[summaryKey]?.translateStatus ==
                    TranslateStatus.loading ||
                translatesState.longTranslates[summaryKey]?.translateStatus ==
                    TranslateStatus.loading;

            void onPressTranslate() {
              final text =
                  isShort
                      ? summaryData.shortSummary.summaryText
                      : summaryData.longSummary.summaryText;

              if (isShort &&
                  !isLoading &&
                  translatesState.shortTranslates[summaryKey] == null) {
                context.read<TranslatesBloc>().add(
                  TranslateSummary(
                    summaryKey: summaryKey,
                    summaryText: text!,
                    languageCode: settingsState.translateLanguage,
                    languageName:
                        languageNames[settingsState.translateLanguage],
                    summaryType: SummaryType.short,
                  ),
                );
                context.read<MixpanelBloc>().add(
                  TrackTranslateSummary(url: summaryKey),
                );
              } else if (isShort &&
                  translatesState.shortTranslates[summaryKey]?.translate !=
                      null) {
                context.read<TranslatesBloc>().add(
                  ToggleTranslate(
                    summaryKey: summaryKey,
                    summaryType: SummaryType.short,
                  ),
                );
              }

              if (!isShort &&
                  !isLoading &&
                  translatesState.longTranslates[summaryKey] == null) {
                context.read<TranslatesBloc>().add(
                  TranslateSummary(
                    summaryKey: summaryKey,
                    summaryText: text!,
                    languageCode: settingsState.translateLanguage,
                    languageName:
                        languageNames[settingsState.translateLanguage],
                    summaryType: SummaryType.long,
                  ),
                );
              } else if (!isShort &&
                  translatesState.longTranslates[summaryKey]?.translate !=
                      null) {
                context.read<TranslatesBloc>().add(
                  ToggleTranslate(
                    summaryKey: summaryKey,
                    summaryType: SummaryType.long,
                  ),
                );
              }
            }

            bool isActive = false;

            if (activeTab == 1) {
              translatesState.shortTranslates[summaryKey] != null &&
                      translatesState.shortTranslates[summaryKey]!.isActive
                  ? isActive = true
                  : isActive = false;
            } else {
              translatesState.longTranslates[summaryKey] != null &&
                      translatesState.longTranslates[summaryKey]!.isActive
                  ? isActive = true
                  : isActive = false;
            }

            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 5, left: 5),
                child: MaterialButton(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  color:
                      isActive ? Colors.white : Theme.of(context).primaryColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  onPressed: onPressTranslate,
                  child: Builder(
                    builder: (context) {
                      if (isShort) {
                        return SizedBox(
                          width: 24,
                          height: 24,
                          child: AnimatedCrossFade(
                            firstChild: SvgPicture.asset(
                              Assets.icons.translate,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isActive
                                    ? Theme.of(context).primaryColorDark
                                    : Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            secondChild: circleLoader(),
                            crossFadeState:
                                translatesState
                                            .shortTranslates[summaryKey]
                                            ?.translateStatus ==
                                        TranslateStatus.loading
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                        );
                      } else {
                        return SizedBox(
                          width: 24,
                          height: 24,
                          child: AnimatedCrossFade(
                            firstChild: SvgPicture.asset(
                              Assets.icons.translate,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isActive
                                    ? Theme.of(context).primaryColorDark
                                    : Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            secondChild: circleLoader(),
                            crossFadeState:
                                translatesState
                                            .longTranslates[summaryKey]
                                            ?.translateStatus ==
                                        TranslateStatus.loading
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget circleLoader() {
  return const Padding(
    padding: EdgeInsets.all(1),
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2.5,
      strokeCap: StrokeCap.round,
    ),
  );
}
