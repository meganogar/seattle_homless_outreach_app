import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'gmap.dart';
import 'showmultmarkers.dart';

import 'fire_auth.dart';
import 'validator.dart';
import 'register_page.dart';
import 'profile_page.dart';

// import 'dart:js' as js;
// import 'dart:html' as html;

// this allows you to interact with Firebase Auth using the default Firebase App 
FirebaseAuth auth = FirebaseAuth.instance;

void createScriptElement(mapsApi) {

  ScriptElement script = ScriptElement();
  script.src = mapsApi;
  script.id = "super-script";

  document.head?.append(script);
}


void main() async {
  /// entry point of our whole program so it must always be defined if you want to render something on the screen, can use arrow notation///
  /// running runApp inside main() function, makes MyApp() root of widget tree (renders widget, and widget's children///
  /// everything in Flutter is a widget, and each one can have its own set of properties and child widgets ///
  /// Stateful widget: manages its own internal state and keeps track of it.///
  /// Stateless widget: while this kind of widget doesn’t manage its own internal state. For example a button.///

  //To expone the dart variable to global js code
  // js.context["my_dart_var"] = mapsApi;
  //Custom DOM event to signal to js the execution of the dart code
  // html.document.dispatchEvent(html.CustomEvent("dart_loaded"));
  await dotenv.load();
  var x = dotenv.env['GOOGLE_MAPS_API_KEY'];
  final String mapsApi = "https://maps.googleapis.com/maps/api/js?key=$x&callback=initMap";

  createScriptElement(mapsApi);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

Map<int, Color> color =
/// This maps out the color of SHO banner blue for use of the Material Color in the app builder, meaning I can use it for AppBar and buttons///
  {
    50:Color.fromRGBO(134,201,210, .1),
    100:Color.fromRGBO(134,201,210, .2),
    200:Color.fromRGBO(134,201,210, .3),
    300:Color.fromRGBO(134,201,210, .4),
    400:Color.fromRGBO(134,201,210, .5),
    500:Color.fromRGBO(134,201,210, .6),
    600:Color.fromRGBO(134,201,210, .7),
    700:Color.fromRGBO(134,201,210, .8),
    800:Color.fromRGBO(134,201,210, .9),
    900:Color.fromRGBO(134,201,210, 1),
  };

/// Where I define SHO banner blue as a Material color so I can use it without error ///
MaterialColor colorCustom = MaterialColor(0xFF86C9D2, color);

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  ///@override marks an instance member as overriding a superclass member with the same name///
  Widget build(BuildContext context) {
    /// MaterialApp widget defining our app title, our app theme, and our login page. introduces Navigator ///
    /// is the starting point of your app, it tells Flutter that you are going to use Material components and follow material design in your app///
    return MaterialApp(
      ///A convenience widget that wraps a number of widgets that are commonly required for material design applications///
      title: 'SHO App',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: const MyLoginPage(title: 'Seattle Homeless Outreach App'),
    );
  }
}

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

  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
      FirebaseApp firebaseApp = await Firebase.initializeApp();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfilePage(
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

    final loginButon = Material(
      ///material widget gives us easier access to aesthetic features///
      elevation: 5.0, ///adds a shadow///
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(190, 32, 46, 1),
      child: MaterialButton(
        ///child to Material Widget, adds the button, below takes text feature as a child///
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),


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
            );

            setState(() {
              _isProcessing = false;
            });

            if (user != null) {
              Navigator.of(context)
                  .pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      ProfilePage(user: user),
                ),
              );
            }
          }
        },


        ///event listener, calls NavMainPage (stateful widget) in the state app///
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

    Future<User?> signInUsingEmailPassword({
      required String email,
      required String password,
      required BuildContext context,
    }) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user;

      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided.');
        }
      }

      return user;
    }

    Future<User?> refreshUser(User user) async {
      FirebaseAuth auth = FirebaseAuth.instance;

      await user.reload();
      User? refreshedUser = auth.currentUser;

      return refreshedUser;
    }

    return Scaffold(
      ///put our widgets together in Scaffold widget ///
      ///let you implement the material standard app widgets that most application has: AppBar, BottomAppBar, FloatingActionButton, BottomSheet, Drawer, Snackbar///
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),

            child: FutureBuilder(
              future: _initializeFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {

                  return Column(
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
                      child: Column(
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
                                      child: loginButon,
                                    ),
                                    SizedBox(width: 24.0),
                                    Expanded(
                                      child: registerButton,
                                    ),
                                  ],
                                )
                        ],
                      ),
                    )


                    ],
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
    );
  }
}

class NavMainPage extends StatelessWidget {
      /// widget that builds the homepage ~ not the login page ///
  const NavMainPage({ Key? key }) : super(key: key);



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
                      onPressed: () {},
                      child: Text('Pending'),
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

                        () => Navigator.pop(context);

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

/// Future things to do
/// 1. Refractor the NavMainPage so that I don't repeat so much code
/// 2. Put classes into seperate folders and import as appropriate
/// 3. Validate the inputs to the encampment_pin_form to make sure they are a number
/// 4. Work on showing current location
