import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF713684),
      body: Center(
        child: SingleChildScrollView(
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
                height: 16,
              ),
              Image.asset('assets/obrazky/wakeup_kid.png'),
              SizedBox(
                height: 16,
              ),
              Text(
                'Ahoj děti,',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: 300,
                child: Text(
                  '''Vítejte v aplikaci WakeUp KID, která vás provede ránem. Můžete si nastavit, co, kdy a jak dlouho ráno děláte. U snídaně si poslechnete, jaká teď platí ve škole koronavirová pravidla. ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Podpořte naši věc a vstávejte včas.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
                  child: Text('Začít'),
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/home', (route) => false))
            ],
          ),
        ),
      ),
    );
  }
}
