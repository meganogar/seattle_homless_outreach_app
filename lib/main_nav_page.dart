import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'fire_auth.dart';
import 'gmap.dart';
import 'showmultmarkers.dart';
import 'main.dart';
import 'profile_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'fire_auth.dart';


import 'main.dart';
import 'main_nav_page.dart';


class MainNavPage extends StatefulWidget {
  final User user;
  const MainNavPage({ Key? key, required this.user }) : super(key: key);


  @override
  _MainNavPageState createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seattle Homless Outreach App'),
        ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    ///Widget to help with spacing, allows us to define height of image///
                    height: 300.0,
                    child: Image.asset(
                      "assets/images/logotrrans.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Gmap()),
                        );
                      },
                      child: Text('Encampment Data'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                        textStyle:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyMaps()),
                        );
                      },
                      child: Text('Special Requests'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                        textStyle:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(user: _currentUser)), 
                        );
                      },
                      child: Text('Profile'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                        textStyle:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MyLoginPage(title: 'Seattle Homeless Outreach App'),
                          ),
                        );

                      },
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                        textStyle:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ]
                ),
            )
          )
    )
  )
  );
  }
}