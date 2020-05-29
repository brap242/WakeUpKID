import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  final String title = 'O aplikaci';

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool showOverlay = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var normalTextStyle = TextStyle(
        color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal);

    return Scaffold(
      backgroundColor: Color(0xFF713684),
      appBar: AppBar(
        backgroundColor: Color(0xFF713684),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Wake Up Kid',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Image.asset('assets/obrazky/wakeup_kid.png'),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '© 2020 PANKINKA',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () => _launchURL('http://www.wakeupkid.cz'),
                    child: Text(
                      'www.wakeupkid.cz',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'COVID-19',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'info na:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(
                        'https://www.msmt.cz/informace-pro-skoly-ke-koronaviru'),
                    child: Text(
                      'www.msmt.cz/informace-pro-skoly-ke-koronaviru',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Číslo účtu sbírky:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '1567972024/3030',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'VS: 202005',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '''Tvůrci:

Pankinka11
a její zákonní zástupci
Bára a Pepe

Grafika:
Jana Macenauerová

Programování:
Michal 242 Dvořák

Nahrávky:
David Hysek

Hlasové vedení:
Jana Franková''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
