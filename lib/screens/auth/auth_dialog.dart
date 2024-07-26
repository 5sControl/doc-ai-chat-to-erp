import 'package:flutter/material.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen.dart';

class AuthDialog extends StatelessWidget {

  final String title;
  final String subTitle;
  final String textButton;
  final VoidCallback onTap;

  const AuthDialog({super.key, required this.title, required this.subTitle, required this.textButton, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      showDialog( 
      context: context, 
      builder: (BuildContext context) { 
        return Dialog( 
          insetPadding: EdgeInsets.all(0), 
          child: Container( 
            width: MediaQuery.of(context).size.width-20, 
            height:230, 
            child: Column( 
              children: [ 
                Row( 
                  mainAxisAlignment: MainAxisAlignment.end, 
                  children: [ 
                    Padding(
                      padding: EdgeInsets.only(right: 15, top: 15),
                      child: Container( 
                        width: 22, 
                        height: 22, 
                        decoration: BoxDecoration( 
                          shape: BoxShape.circle, 
                          border: Border.all(color: Colors.black), 
                        ), 
                        child: IconButton( 
                          padding: EdgeInsets.all(0), 
                          icon: const Icon( 
                            Icons.close_rounded, 
                            size: 15, 
                          ), 
                          onPressed: () { 
                            Navigator.of(context).pop(); 
                          }, 
                        ), 
                      ),
                    ), 
                  ], 
                ), 
                Center( 
                  child: Text( 
                    title, 
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25), 
                  ), 
                ), 
                const SizedBox(height: 7,),
                Expanded( 
                  child: Center( 
                    child: Text( 
                      subTitle, 
                      textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w300),
                    ), 
                  ), 
                ), 
                const SizedBox(height: 10,),
                InkWell( 
                  onTap: onTap,
                  child: Container( 
                    alignment: Alignment.center, 
                    padding: const EdgeInsets.symmetric(vertical: 10), 
                    width: MediaQuery.of(context).size.width - 60, 
                    decoration: BoxDecoration( 
                      color: Colors.teal.shade300, 
                      borderRadius: BorderRadius.circular(12), 
                    ), // End BoxDecoration
                    child: Text( 
                      textButton, 
                      style: TextStyle( 
                        color: Colors.white, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 18, 
                      ), 
                    ), 
                  ), 
                ), 
                SizedBox(height: 18), 
              ], 
            ), 
          ), 
        ); 
      }, 
    ); 
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 18),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.teal.shade300,
            borderRadius: BorderRadius.circular(8)),
        child: const Text(
          'Login in',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}