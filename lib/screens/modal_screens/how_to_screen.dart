import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../gen/assets.gen.dart';

class HowToScreen extends StatefulWidget {
  const HowToScreen({super.key});

  @override
  State<HowToScreen> createState() => _HowToScreenState();
}

class _HowToScreenState extends State<HowToScreen> {
  late AssetImage image;

  @override
  void initState() {
    context.read<MixpanelBloc>().add(const ShowInstructions());
    super.initState();
    image = AssetImage(Assets.gif.howTo.path);
  }

  @override
  void dispose() {
    image.evict();
    context.read<MixpanelBloc>().add(const CloseInstructions());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Scaffold(
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Setup share button',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
                              )),
                          IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.read<MixpanelBloc>().add(const CloseInstructions());
                              },
                              style: ButtonStyle(
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.all(2)),
                                  backgroundColor: MaterialStatePropertyAll(
                                      const Color.fromRGBO(255, 255, 255, 1.0)
                                          .withOpacity(0.1))),
                              highlightColor:
                                  const Color.fromRGBO(255, 255, 255, 1.0)
                                      .withOpacity(0.2),
                              icon: const Icon(
                                Icons.close,
                                color: Color.fromRGBO(255, 255, 255, 1.0),
                              )),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image(
                            image: image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
