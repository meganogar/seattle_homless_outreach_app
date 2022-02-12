import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sho_app/locations.dart';

import 'gmap.dart';


import 'validator.dart';

class NewCamp extends StatefulWidget {
  final LatLongF location;

  const NewCamp({ Key? key, required this.location }) : super(key: key);

  @override
  _NewCampState createState() => _NewCampState();
}

class _NewCampState extends State<NewCamp> {
  
  final _formKey = GlobalKey<FormState>();

  final _titleTextController = TextEditingController();
  final _snippetTextController = TextEditingController();

  final _focusTitle = FocusNode();
  final _focusSnippet = FocusNode();

  final _refCamp = FirebaseDatabase.instance.ref("CampsTest");

  // _refCamp.push().set({
  //   // 'markerId': idCounter3,
  //   'latitude': latlang.latitude,
  //   'longitude': latlang.longitude
  // });

  late LatLongF location;

  @override
  void initState() {
    location = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
return Container(
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Add TextFormFields and ElevatedButton here.
                  TextFormField(
                    controller: _titleTextController,
                    focusNode: _focusTitle,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      labelText: 'Name of Encampment',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) => Validator.validateName(
                      name: value!,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _snippetTextController,
                    focusNode: _focusSnippet,
                      decoration: InputDecoration(
                        border: 
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        labelText: 'Location Description',
                      ),
                    // The validator receives the text that the user has entered.
                    validator: (value) => Validator.validateName(
                      name: value!,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                          // API Call to database
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      _focusTitle.unfocus();
                      _focusSnippet.unfocus();

                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        // Won't show because it's in the modal popup
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Processing Data')),
                        // );

                      _refCamp.push().set({

                        'latitude': location.latitude,
                        'longitude': location.longitude,
                        'title': _titleTextController.text,
                        'snippet': _snippetTextController.text
                      });

                      }
                    },
                    child: const Text('Create Camp'),
                  )
                ],
              ),
            )
        )
      )
    );
  }
}