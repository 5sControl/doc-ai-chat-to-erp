import 'package:flutter/material.dart';
import 'package:summify/widgets/backgroung_gradient.dart';
import 'package:url_launcher/url_launcher.dart';

const String _supportEmail = 'support@englishingames.com';

class RequestScreen extends StatefulWidget {
  final String? initialMessage;
  final String title;

  const RequestScreen({
    super.key,
    this.initialMessage,
    this.title = 'Request a feature',
  });

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  Set<String> selectedOptions = {};
  final messageController = TextEditingController();

  @override
  void initState() {
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      messageController.text = widget.initialMessage!;
    }
    super.initState();
  }

  void onSelectOption({required String option}) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  Future<void> onPressSubmit() async {
    final subject = 'Summify: ${widget.title}';
    final bodyParts = <String>[];
    if (selectedOptions.isNotEmpty) {
      bodyParts.add('Selected options:');
      for (final option in selectedOptions) {
        bodyParts.add('- $option');
      }
      bodyParts.add('');
    }
    final messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      bodyParts.add(messageText);
    }
    final body = bodyParts.join('\n');
    final mailtoUrl = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {'subject': subject, 'body': body},
    );
    try {
      final launched = await launchUrl(
        mailtoUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!mounted) return;
      if (launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Почтовое приложение открыто. Отправьте письмо, когда будете готовы.',
            ),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Не удалось открыть почту. Установите приложение почты или проверьте настройки.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ошибка: $e',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> options = [
      'Secure summarization',
      'Read my book',
      'Speech to text feature',
      'Text to speech feature',
      'Add language',
      'Support for large files',
      'Work with groups of files',
    ];

    return Stack(
      fit: StackFit.loose,
      children: [
        const BackgroundGradient(),
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 10,
                left: 15,
                right: 15,
                top: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...options.map(
                    (option) => OptionContainer(
                      title: option,
                      selectedOptions: selectedOptions,
                      onSelectOption: onSelectOption,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Or write us a message',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  MessageInput(controller: messageController),
                  const SizedBox(height: 16),
                  ConfirmButton(onPressSubmit: onPressSubmit),
                  SizedBox(
                    height: MediaQuery.of(context).size.shortestSide < 600
                        ? 10
                        : 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MessageInput extends StatelessWidget {
  final TextEditingController controller;

  const MessageInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const Text('Message'),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          minLines: 4,
          maxLines: 12,
          decoration: const InputDecoration(
            hintText: ' Enter your request',
          ),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressSubmit;

  const ConfirmButton({super.key, required this.onPressSubmit});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).hintColor,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        highlightColor: Colors.white24,
        borderRadius: BorderRadius.circular(8),
        onTap: onPressSubmit,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
            'Submit',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class OptionContainer extends StatelessWidget {
  final String title;
  final Set<String> selectedOptions;
  final Function({required String option}) onSelectOption;

  const OptionContainer({
    super.key,
    required this.title,
    required this.selectedOptions,
    required this.onSelectOption,
  });

  @override
  Widget build(BuildContext context) {
    final isAddLanguage = title == 'Add language';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Checkbox(
            value: selectedOptions.contains(title),
            onChanged: (_) => onSelectOption(option: title),
            activeColor: Colors.white,
            checkColor: Theme.of(context).hintColor,
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return Colors.white24;
            }),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.white),
                ),
                if (isAddLanguage)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Add a language — write which one in the message below',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
