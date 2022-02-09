import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Validator {
  ///alidators will help to check whether the user has entered any 
  ///inappropriate value in a specific field and show an error accordingly
  
  static String? validateName({required String name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String email}) {
    //checks that given email is valid, if not valid email, doesn't go through
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String password}) {
    //checks that the password is a greater than 6, firebase doesn't allow passwords less than six
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6'; 
    }

    return null;
  }

  static String? validateNumber({required String input}) {
    //
    if (input == null || input.isEmpty) {
      return 'Please enter some text';
    } 
    // else if (isNumeric(input) != true) {
    //   return 'Please enter a number';
    // }

    return null;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
      return double.tryParse(s) != null;
  }

  
}