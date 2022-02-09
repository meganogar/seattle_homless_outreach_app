import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import 'validator.dart';

class EncampmentPinForm extends StatefulWidget {


  const EncampmentPinForm({ Key? key }) : super(key: key);

  

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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    
    final _refTents = FirebaseDatabase.instance.ref("Tents");
    final _refBags = FirebaseDatabase.instance.ref("Bags");
    final _refDate = FirebaseDatabase.instance.ref("Date");

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
                    onPressed: () {
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

                        print(_tentsTextController.text);
                        print(_bagsTextController.text);
                        print(today);
                        _refTents.set(_tentsTextController.text);
                        _refBags.set(_bagsTextController.text);
                        _refDate.set(today);
                      }
                    },
                    child: const Text('Send Data'),
                  )
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