import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      labelText: '# of Tents',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value != int)
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      decoration: InputDecoration(
                        border: 
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        labelText: '# of Bags distributed',
                      ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value != int)
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                          // API Call to database
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.

                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        // Won't show because it's in the modal popup
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
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
}