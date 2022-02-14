import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:sho_app/google_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'gmap.dart';
import 'showmultmarkers.dart';

import 'fire_auth.dart';
import 'validator.dart';
import 'register_page.dart';
import 'profile_page.dart';
import 'main_nav_page.dart';
import 'login_page.dart';
import 'google_auth.dart';



class MyLoginPage extends StatefulWidget {
  /// contain fields that affect how it looks ///

  const MyLoginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  ///  responsible for defining our MyLoginPage widget state ///
  /// Prefixing an identifier with an underscore enforces privacy in the Dart language and is a recommended best practice for State objects ///
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  final _formKey = GlobalKey<FormState>(); //sets a key for the form so that items are grouped

  // creates controllers for the editable fields, presumeably so we can capture what is inputted
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();


  // persistent objects that form a focus tree that is a representation of the widgets in the 
  // hierarchy that are interested in focus. A focus node might need to be created if it is passed 
  // in from an ancestor of a Focus widget to control the focus of the children from the ancestor, 
  // or a widget might need to host one if the widget subsystem is not being used
  // a listener can be registered to receive a notification when the focus changes
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool _smallScreen = false;

  //  retrieves the current user, if it's not null, directs directly to teh MainNavPage
  // remembers previous state

  Future<FirebaseApp> _initializeFirebase() async {
      FirebaseApp firebaseApp = await Firebase.initializeApp();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainNavPage(
              user: user,
            ),
          ),
        );
      }
      return firebaseApp;
  }


  /// defines the custom font to apply in app UI ///
  TextStyle style = TextStyle(fontFamily: 'Charis SIL Regular', fontSize: 20.0);


  @override
  ///override the build function that returns our main widget///
  Widget build(BuildContext context) {

    ///define our UI elements///
    ///final keyword simply tells our app that the object value won’t be modified throughout the app ///

    final emailField = TextFormField(
      obscureText: false,
      style: style,

      controller: _emailTextController,
      focusNode: _focusEmail,
      validator: (value) => Validator.validateEmail(email: value!),

      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextFormField(
      obscureText: true,  ///hide the value of the input ///
      style: style,

      controller: _passwordTextController,
      focusNode: _focusPassword,
      validator: (value) => Validator.validatePassword(password: value!),

      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
      ///material widget gives us easier access to aesthetic features///
      elevation: 5.0, ///adds a shadow///
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(190, 32, 46, 1),
      child: MaterialButton(
        ///child to Material Widget, adds the button, below takes text feature as a child///
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        //Takes the focus off the email and passowrd, checks that they are valid and sends to firebase
        //If valid sign in will update state to false and sends user to Main Nav Page

        onPressed: () async {
          _focusEmail.unfocus();
          _focusPassword.unfocus();

          if (_formKey.currentState!
              .validate()) {
            setState(() {
              _isProcessing = true;
            });

            User? user = await FireAuth
                .signInUsingEmailPassword(
              email: _emailTextController.text,
              password:
                  _passwordTextController.text,
              context: context,
            );

            setState(() {
              _isProcessing = false;
            });

            if (user != null) {
              Navigator.of(context)
                  .pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      MainNavPage(user: user),
                ),
              );
            }
          }
        }, ///event listener, calls NavMainPage (stateful widget) in the state app///
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final registerButton = Material(
      ///material widget gives us easier access to aesthetic features///
      elevation: 5.0, ///adds a shadow///
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(190, 32, 46, 1),
      child: MaterialButton(
        ///child to Material Widget, adds the button, below takes text feature as a child///
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => RegisterPage()),
          );
        }, ///event listener, calls NavMainPage (stateful widget) in the state app///

        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final googleAuthTent = IconButton(
      icon: Image.asset(
        "assets/images/asset_2.png",
        fit: BoxFit.contain
      ),
      iconSize: 50,
      onPressed: () async{
        setState(() {
          _isProcessing = true;
        });

        User? user = await Authentication.signInWithGoogle(context: context);

        setState(() {
          _isProcessing = false;
        });

        if (user != null) {
          Navigator.of(context)
              .pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  MainNavPage(user: user),
            ),
          );
        }
      },
    ); 

    final MediaQueryData mediaQueryData;

    final width = MediaQuery.of(context).size.width;
    
    
    if (width < 365 ) {

      setState(() {
        _smallScreen = true;
      });

    }
  

    return SafeArea(
      top: true,
      bottom: true,

      child: 
    
      Scaffold(
        
        ///put our widgets together in Scaffold widget ///
        ///let you implement the material standard app widgets that most application has: AppBar, BottomAppBar, FloatingActionButton, BottomSheet, Drawer, Snackbar///
        body: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              //Firebase is an async method, so we need to use future builder to indicate it should build once method completes
              child: FutureBuilder(
                future: _initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {

                    return 
                    SingleChildScrollView(
                    
                      child: Column(
                        /// Column widget allows us to align form elements vertically ///
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
                          

                          Form(
                          key: _formKey, 
                          child: 
                          _smallScreen
                            ? Column(
                              children: <Widget>[
                                        
                                emailField,
                                SizedBox(height: 25.0),
                                passwordField,
                                SizedBox(height: 35.0,),

                                _isProcessing
                                  ? CircularProgressIndicator()
                                  : Column(
                                    children: <Widget>[
                                      loginButton,
                                      SizedBox(height: 25.0),
                                      registerButton,
                                      SizedBox(height: 25.0),
                                      googleAuthTent  
                                    ]
                                  )
                              ]
                            )
                            : Column(
                              children: <Widget>[
                                        
                                emailField,
                                SizedBox(height: 25.0),
                                passwordField,
                                SizedBox(height: 35.0,),
                                _isProcessing
                                  ? CircularProgressIndicator()
                                  : Row(
                                    
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: loginButton,
                                        ),
                                        SizedBox(width: 24.0),
                                        Expanded(
                                          child: registerButton,
                                        ),
                                        SizedBox(width: 10.0),
                                        googleAuthTent
                                      ],
                                    )

                              ],
                            ),
                        )


                        ],
                      )
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
      )
    );
  }
}