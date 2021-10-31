import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class resultPage extends StatefulWidget {
  const resultPage({Key? key}) : super(key: key);

  @override
  _resultPageState createState() => _resultPageState();
}

class _resultPageState extends State<resultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.fill,
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.all(10),
                  child: Image.asset("assets/images/vote_hand.png"
                      ,height: 120.0),
                ),
                Text('Exit Poll',style: GoogleFonts.prompt(fontSize: 20.0,color: Colors.white)),


              ],
            ),
          ],
        ),
      ),

    );
  }
}
