import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../services/tts_service.dart';

class TtsSettingsSection extends StatefulWidget {
  const TtsSettingsSection({super.key});

  @override
  State<TtsSettingsSection> createState() => _TtsSettingsSectionState();
}

class _TtsSettingsSectionState extends State<TtsSettingsSection> {
  late final Future<void> _voicesLoader;

  @override
  void initState() {
    super.initState();
    _voicesLoader = TtsService.instance.ensureVoicesLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _voicesLoader,
      builder: (context, snapshot) {
        final isLoadingVoices =
            snapshot.connectionState == ConnectionState.waiting;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Voice settings',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return ValueListenableBuilder<List<TtsVoice>>(
                    valueListenable: TtsService.instance.voiceListNotifier,
                    builder: (context, voices, _) {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(),
                        ),
                        value: state.kokoroVoiceId,
                        items:
                            voices
                                .map(
                                  (voice) => DropdownMenuItem(
                                    value: voice.id,
                                    child: Text(voice.name),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            voices.isEmpty
                                ? null
                                : (value) {
                                  if (value != null) {
                                    context.read<SettingsBloc>().add(
                                      SetKokoroVoiceId(kokoroVoiceId: value),
                                    );
                                  }
                                },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Synthesis speed (${state.kokoroSynthesisSpeed.toStringAsFixed(2)})',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Slider(
                        value: state.kokoroSynthesisSpeed,
                        min: 0.5,
                        max: 2.0,
                        divisions: 30,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                            SetKokoroSynthesisSpeed(
                              kokoroSynthesisSpeed: value,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              if (isLoadingVoices)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}
