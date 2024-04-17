import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:summify/helpers/email_validator.dart';
import 'package:summify/helpers/language_codes.dart';
import 'package:summify/services/summaryApi.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  Set<String> selectedOptions = {};
  String selectedLang = '';
  bool emailError = false;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void initState() {
    emailController.addListener(() {
      if (validateEmail(emailController.value.text) == null) {
        setState(() {
          emailError = false;
        });
      } else {
        setState(() {
          emailError = true;
        });
      }
    });
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

  void onSelectLang({required String lang}) {
    setState(() {
      selectedLang = lang;
    });
  }

  void onPressSubmit() async {
    if (!emailError && emailController.value.text.isNotEmpty) {
      final res = await SummaryRepository().sendFeature(
          getMoreSummaries: selectedOptions.contains('I need more summaries'),
          addTranslation: selectedOptions.contains('Summary translation'),
          askAQuestions: selectedOptions.contains('AI summary chat'),
          addLang: selectedOptions.contains('Add language')
              ? selectedLang
              : 'Not selected',
          name:
              nameController.text.isNotEmpty ? nameController.text : 'Unknown',
          email: emailController.text,
          message: messageController.text);

      print(res);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> options = [
      'I need more summaries',
      'Summary translation',
      'AI summary chat',
      'Add language'
    ];

    return Stack(
      fit: StackFit.loose,
      children: [
        const BackgroundGradient(),
        Scaffold(
            // resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text(
                'Request a feature',
                style: TextStyle(color: Colors.black),
              ),
            ),
            // extendBody: true,
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.bottom -
                        MediaQuery.of(context).padding.top -
                        (MediaQuery.of(context).viewInsets.bottom / 2)),
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 10,
                      left: 15,
                      right: 15,
                      top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: options
                            .map((option) => OptionContainer(
                                title: option,
                                selectedOptions: selectedOptions,
                                onSelectOption: onSelectOption,
                                onSelectLang: onSelectLang))
                            .toList(),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      const Text(
                        'Or write us a message',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      CustomInput(
                        title: 'Name',
                        placeholder: 'Enter your name',
                        required: false,
                        controller: nameController,
                      ),
                      CustomInput(
                        title: 'Email',
                        placeholder: 'Enter your email',
                        required: true,
                        controller: emailController,
                      ),
                      CustomInput(
                        title: 'Message',
                        placeholder: 'Enter your request',
                        required: false,
                        controller: messageController,
                      ),
                      Spacer(),
                      ConfirmButton(
                          onPressSubmit: onPressSubmit, emailError: emailError)
                    ],
                  ),
                ),
              ),
              // child: SingleChildScrollView(
              //   child: Container(
              //     // color: Colors.red,
              //     padding: EdgeInsets.all(20.0),
              //     child: IntrinsicHeight(
              //       child: ConstrainedBox(
              //         constraints: BoxConstraints(
              //             maxHeight: MediaQuery.of(context).size.height -
              //                 MediaQuery.of(context).padding.bottom -
              //                 MediaQuery.of(context).padding.top),
              //         child: Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.stretch,
              //             mainAxisSize: MainAxisSize.max,
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.stretch,
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: options
              //                     .map((option) => OptionContainer(
              //                         title: option,
              //                         selectedOptions: selectedOptions,
              //                         onSelectOption: onSelectOption,
              //                         onSelectLang: onSelectLang))
              //                     .toList(),
              //               ),
              //               const Divider(
              //                 color: Colors.transparent,
              //               ),
              //               const Text(
              //                 'Or write us a message',
              //                 style: TextStyle(
              //                     fontSize: 18, fontWeight: FontWeight.w500),
              //               ),
              //               CustomInput(
              //                 title: 'Name',
              //                 placeholder: 'Enter your name',
              //                 required: false,
              //                 controller: nameController,
              //               ),
              //               CustomInput(
              //                 title: 'Email',
              //                 placeholder: 'Enter your email',
              //                 required: true,
              //                 controller: emailController,
              //               ),
              //               CustomInput(
              //                 title: 'Message',
              //                 placeholder: 'Enter your request',
              //                 required: false,
              //                 controller: messageController,
              //               ),
              //               // const Spacer(),
              //               Divider(
              //                 color: Colors.transparent,
              //               ),
              //               Spacer(),
              //               ConfirmButton(
              //                   onPressSubmit: onPressSubmit,
              //                   emailError: emailError)
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            )
            // body: SingleChildScrollView(
            //   child: ConstrainedBox(
            //     constraints: BoxConstraints(
            //       maxHeight: MediaQuery.of(context).size.height -
            //           MediaQuery.of(context).padding.bottom -
            //           MediaQuery.of(context).padding.top -
            //           10,
            //     ),
            //     child: Container(
            //       padding: EdgeInsets.only(
            //           left: 15,
            //           right: 15,
            //           top: 10,
            //           bottom: MediaQuery.of(context).padding.bottom +
            //               MediaQuery.of(context).viewInsets.bottom +
            //               10),
            //       child: Column(
            //         mainAxisSize: MainAxisSize.max,
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.stretch,
            //             children: options
            //                 .map((option) => OptionContainer(
            //                     title: option,
            //                     selectedOptions: selectedOptions,
            //                     onSelectOption: onSelectOption,
            //                     onSelectLang: onSelectLang))
            //                 .toList(),
            //           ),
            //           const Divider(
            //             color: Colors.transparent,
            //           ),
            //           const Text(
            //             'Or write us a message',
            //             style:
            //                 TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            //           ),
            //           CustomInput(
            //             title: 'Name',
            //             placeholder: 'Enter your name',
            //             required: false,
            //             controller: nameController,
            //           ),
            //           CustomInput(
            //             title: 'Email',
            //             placeholder: 'Enter your email',
            //             required: true,
            //             controller: emailController,
            //           ),
            //           CustomInput(
            //             title: 'Message',
            //             placeholder: 'Enter your request',
            //             required: false,
            //             controller: messageController,
            //           ),
            //           const Spacer(),
            //           Divider(
            //             color: Colors.transparent,
            //           ),
            //           ConfirmButton(
            //               onPressSubmit: onPressSubmit, emailError: emailError)
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            ),
      ],
    );
  }
}

class CustomInput extends StatefulWidget {
  final String title;
  final String placeholder;
  final bool required;
  final TextEditingController? controller;

  const CustomInput(
      {super.key,
      required this.title,
      required this.placeholder,
      required this.required,
      this.controller});

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          color: Colors.transparent,
        ),
        Row(
          children: [
            Text(widget.title),
            if (widget.required)
              const Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        TextFormField(
          controller: widget.controller,
          autovalidateMode: widget.title == 'Email'
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: widget.title == 'Email' ? validateEmail : null,
          textInputAction: TextInputAction.done,
          keyboardType: widget.title == 'Email'
              ? TextInputType.emailAddress
              : TextInputType.text,
          // onEditingComplete: () {},
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              gapPadding: 10,
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 2, color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              gapPadding: 10,
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(width: 2, color: Theme.of(context).primaryColor),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: widget.placeholder,
            border: OutlineInputBorder(
                gapPadding: 10,
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressSubmit;
  final bool emailError;
  const ConfirmButton(
      {super.key, required this.onPressSubmit, required this.emailError});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        highlightColor:
            !emailError ? Colors.white24 : Colors.red.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        onTap: onPressSubmit,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
            'Submit',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
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
  final Function({required String lang}) onSelectLang;
  const OptionContainer(
      {super.key,
      required this.title,
      required this.selectedOptions,
      required this.onSelectOption,
      required this.onSelectLang});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            side: const BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: Colors.white,
                strokeAlign: BorderSide.strokeAlignOutside),
            overlayColor: const MaterialStatePropertyAll(Colors.white38),
            activeColor: Colors.white,
            checkColor: Theme.of(context).primaryColor,
            value: selectedOptions.contains(title),
            onChanged: (_) => onSelectOption(option: title),
          ),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
          ),
          // Spacer(),
          SizedBox(
            width: 20,
          ),
          if (title == 'Add language')
            Flexible(
              child: AnimatedCrossFade(
                  firstChild: LanguagesDropdown(onSelectLang: onSelectLang),
                  secondChild: Container(),
                  crossFadeState: selectedOptions.contains(title)
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 500)),
            )
        ],
      ),
    );
  }
}

class LanguagesDropdown extends StatefulWidget {
  final Function({required String lang}) onSelectLang;
  const LanguagesDropdown({super.key, required this.onSelectLang});

  @override
  State<LanguagesDropdown> createState() => _LanguagesDropdownState();
}

class _LanguagesDropdownState extends State<LanguagesDropdown> {
  String? selectedLang;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.zero,
      splashColor: Colors.white,
      alignedDropdown: true,
      child: DropdownButton(
        value: selectedLang,
        alignment: Alignment.centerRight,
        isExpanded: true,
        dropdownColor: Theme.of(context).primaryColor.withOpacity(1),
        isDense: true,
        hint: Text(selectedLang ?? 'Select language',
            textAlign: TextAlign.end,
            overflow: TextOverflow.visible,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            )),
        menuMaxHeight: 300,
        padding: EdgeInsets.zero,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        // underline: Divider(),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
        ),
        items: languages.values.map((lang) {
          return DropdownMenuItem<String>(
            // alignment: Alignment.centerRight,
            value: lang,
            child: Text(
              lang,
              textAlign: TextAlign.end,
            ),
          );
        }).toList(),

        onChanged: (val) {
          setState(() {
            selectedLang = val;
            widget.onSelectLang(lang: val!);
          });
        },
      ),
    );
  }
}
