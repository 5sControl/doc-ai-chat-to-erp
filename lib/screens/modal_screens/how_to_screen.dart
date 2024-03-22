import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
    super.initState();
    image = AssetImage(Assets.gif.howTo.path);
  }

  @override
  void dispose() {
    image.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Scaffold(
              // appBar: AppBar(
              //   automaticallyImplyLeading: false,
              //   title: Text('asdasdasdasdasd'),
              // ),
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
