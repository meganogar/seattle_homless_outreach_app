import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  // For registering a new user with email & password and associated them with this user, again, needs to be a future
  // since it makes a call to firebase

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword( //uses the firebase auth predefined method
        email: email,
        password: password,
      );

      user = userCredential.user;  //assigns the user as userCredential to give them access additional methods
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) { //catches any errors for the email/password strength
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword( //sends credentials to firebase and assins return value as User object
        email: email,
        password: password,
      );
      user = userCredential.user; //associates returned value of firebase to current user
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {

        showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text('No user found for that email.'),
              // actions: [
              //   TextButton(
              //       onPressed: () {
              //         // Close the dialog
              //         Navigator.of(context).pop();
              //       },
              //       child: const Text('Okay'))
              // ],
            );
        });

      } else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text('Wrong password provided.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await auth.sendPasswordResetEmail(email: email);
                    Navigator.of(context).pop();
                  }, 
                  child: const Text('Send password reset to my email.')),
                
              ],
            );
        });

      }
    }

    return user;
  }


  //final method that refreshes user, the ? is a null check
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

}