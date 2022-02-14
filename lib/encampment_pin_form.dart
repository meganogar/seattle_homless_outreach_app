import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'gmap.dart';


import 'validator.dart';

class EncampmentPinForm extends StatefulWidget {
  final Camp camp;

  const EncampmentPinForm({ Key? key , required this.camp}) : super(key: key);

  

  @override
  _EncampmentPinFormState createState() => _EncampmentPinFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _EncampmentPinFormState extends State<EncampmentPinForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final _tentsTextController = TextEditingController();
  final _bagsTextController = TextEditingController();

  final _focusTents = FocusNode();
  final _focusBags = FocusNode();

  final database = FirebaseDatabase.instance;

  var today = DateFormat.yMMMd().format(DateTime.now());
  var dateTimeToday = DateFormat.Hms().format(DateTime.now());

  late Camp camp;

  

  @override
  void initState() {
    camp = widget.camp;
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    
    final _refCamp = FirebaseDatabase.instance.ref("CampsTest/${camp.id}/Outreaches/");
    final _refRemoveCamp = FirebaseDatabase.instance.ref("CampsTest/${camp.id}");

    bool _isShown = true;

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Please Confirm Deletion'),
            content: Text('Only delete this camp if created in error'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    _refRemoveCamp.remove();
                    setState(() {
                      _isShown = false;
                    });

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Nevermind'))
            ],
          );
    });
  }


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
                    controller: _tentsTextController,
                    focusNode: _focusTents,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      labelText: '# of Tents',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) => Validator.validateNumber(
                      input: value!,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _bagsTextController,
                    focusNode: _focusBags,
                      decoration: InputDecoration(
                        border: 
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        labelText: '# of Bags distributed',
                      ),
                    // The validator receives the text that the user has entered.
                    validator: (value) => Validator.validateNumber(
                      input: value!,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                          // API Call to database
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      _focusTents.unfocus();
                      _focusBags.unfocus();

                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        // Won't show because it's in the modal popup
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Processing Data')),
                        // );

                        await _refCamp.push().set({
                          'tents': _tentsTextController.text, 
                          'bags': _bagsTextController.text, 
                          'date': today, 
                          'datetime': dateTimeToday,
                          'user_id': FirebaseAuth.instance.currentUser!.uid,
                          'user': FirebaseAuth.instance.currentUser!.displayName
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Send Data'),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _isShown == true ? () => _delete(context) : null,
                    child: const Text('Delete Camp?'))
                ],
              ),
            )
        )
      )
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _tentsTextController.dispose();
    _bagsTextController.dispose();
    super.dispose();
  }
}

final databaseRef = FirebaseDatabase.instance.ref(); //database reference object

