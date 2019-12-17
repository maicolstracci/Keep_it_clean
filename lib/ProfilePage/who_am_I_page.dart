import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhoAmIPage extends StatelessWidget {

  void _contact() async {
    final url = 'mailto:maicolstracci95@hotmail.it';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[400],
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height*0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: ExactAssetImage('assets/profileTest.jpeg'),
                  maxRadius: 80,
                ),
                Text("Maicol Stracci"),
                Text("Flutter developer"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Finale Ligure (SV)"),
                    Icon(Icons.favorite, size: 20, color: Colors.red,)
                  ],
                ),
                Text("Trovato un bug?"),
                FlatButton(child: Text("Contattami"),
                onPressed: () {
                  _contact();
                },
                textColor: Colors.white,
                color: Colors.lightBlueAccent[400],)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
