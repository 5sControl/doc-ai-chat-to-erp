import 'package:flutter/material.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.loose,
      children: [
        const BackgroundGradient(),
        DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 40,
              title: const Text(
                'Upload',
                style: TextStyle(color: Colors.black),
              ),
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: Size(deviceWidth, 50.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8)),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.center,
                    tabs: [
                      Container(
                        width: deviceWidth / 3 - 10,
                        child: const Tab(text: 'Text', height: 30),
                      ),
                      Container(
                        width: deviceWidth / 3 - 10,
                        child: const Tab(
                          text: 'URL',
                          height: 30,
                        ),
                      ),
                      Container(
                        width: deviceWidth / 3 - 10,
                        child: const Tab(
                          text: 'Upload',
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: deviceWidth - 100,
                  ),
                  child: TabBarView(
                    clipBehavior: Clip.hardEdge,
                    viewportFraction: 1,
                    children: [
                      Container(
                        height: deviceWidth,
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(8)),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(
                                  color: Colors.teal.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child:  TextField(
                            maxLines: null,
                            autofocus: false,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.top,
                            cursorWidth: 3,
                            cursorColor: Colors.black54,
                            cursorHeight: 20,
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                // filled: true,
                                label: Text('Start typing or paste your content here ...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                // floatingLabelAlignment: FloatingLabelAlignment.start,
                                // floatingLabelBehavior: FloatingLabelBehavior.auto,
                                // label: const Padding(
                                //   padding: EdgeInsets.only(bottom: 25),
                                //   child: Text(
                                //     'Email',
                                //     style: TextStyle(),
                                //   ),
                                // ),
                                border: OutlineInputBorder(
                                    gapPadding: 10,
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                // floatingLabelStyle: const TextStyle(
                                //     color: Colors.white,
                                //     // height: -2,
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.w500)
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: deviceWidth,
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(8)),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(
                                  color: Colors.teal.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      Container(
                        height: deviceWidth,
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(8)),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(
                                  color: Colors.teal.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: deviceWidth,
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(4, 49, 57, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    'Summify Now',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],

            ),
          ),
        )
      ],
    );
  }
}
