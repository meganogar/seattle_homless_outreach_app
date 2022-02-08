import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'fire_auth.dart';

import 'login_page.dart';


class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({ Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;
  TextStyle style = TextStyle(fontFamily: 'Charis SIL Regular', fontSize: 20.0);

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: ${_currentUser.displayName}',
              style: style.copyWith(fontSize: 17),
            ),
            SizedBox(height: 16.0),
            Text(
              'Email: ${_currentUser.email}',
              style: style.copyWith(fontSize: 17),
            ),
            SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? 
                  Text(
                    'Email verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.green),
                  )
                : Text(
                    'Email not verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Color.fromRGBO(190, 32, 46, 1)),
                  ),
            SizedBox(height: 16.0),
            _isSendingVerification
                ? CircularProgressIndicator()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isSendingVerification = true;
                          });
                          await _currentUser.sendEmailVerification(); //built in method to verify email for current user
                          setState(() {
                            _isSendingVerification = false;
                          });
                        },
                        child: Text('Verify email'),
                        style: ElevatedButton.styleFrom(
                          textStyle: style.copyWith(fontSize: 17),
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                        
                        
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          User? user = await FireAuth.refreshUser(_currentUser);

                          if (user != null) {
                            setState(() {
                              _currentUser = user;
                            });
                          }
                        },
                      ),
                    ],
                  ),
            SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator()
                : 
                
                
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MyLoginPage(title: 'Seattle Homeless Outreach App'),
                        ),
                      );
                    },
                    child: Text('Sign out'),
                    style: ElevatedButton.styleFrom(
                      textStyle: style.copyWith(fontSize: 17),
                      padding: EdgeInsets.fromLTRB(35.0, 15.0, 35.0, 15.0),
                      primary: Color.fromRGBO(190, 32, 46, 1),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

