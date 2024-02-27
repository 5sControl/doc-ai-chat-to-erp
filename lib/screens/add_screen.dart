import 'package:flutter/material.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundGradient(),
        Align(
          alignment: Alignment.topRight,
          child: Transform.scale(
            scale: 0.7,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.close, color: Colors.white,),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white38)
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 100),
          decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(12)
          ),
        )
      ],
    );
  }
}
