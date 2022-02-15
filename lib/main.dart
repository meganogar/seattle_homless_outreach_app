import 'dart:html';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

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
  
  // await dotenv.load();
  // var x = dotenv.env['GOOGLE_MAPS_API_KEY'];
  // final String mapsApi = "https://maps.googleapis.com/maps/api/js?key=$x"; //&callback=initMap

  // createScriptElement(mapsApi);
  
  // Inititalizes the Firebase App, it is an async method 
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

      return 
      
        MaterialApp(
          ///A convenience widget that wraps a number of widgets that are commonly required for material design applications///
          title: 'SHO App',
          
          theme: ThemeData(
            primarySwatch: colorCustom,
          ),
          home: MyLoginPage(title: 'Seattle Homeless Outreach App'),
        );

    }
}

/// Future things to do
/// 1. Refractor the NavMainPage so that I don't repeat so much code
/// 2. Put classes into seperate folders and import as appropriate
/// 3. Validate the inputs to the encampment_pin_form to make sure they are a number
/// 4. Work on showing current location
/// 5. Update the login authentication so that when you enter a wrong password there is a message sent to user
/// 6. Update the registration page so that if you don't have valid inpu you don't just get the doom spin 4eva

