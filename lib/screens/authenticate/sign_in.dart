import 'package:lab3/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3/shared/constants.dart';
import 'package:lab3/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn( this.toggleView );

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Sign in'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () {
                widget.toggleView();
              },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  }
                  ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  child: Text(
                    'Sign in',
                    style:TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Change the background color here
                  ),
                  onPressed: () async {
                     if (_formKey.currentState!.validate()) {
                       setState(() => loading = true);
                       dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                       if (result == null) {
                        setState(() {
                           error = 'could not sign in with those credentials';
                           loading = false;
                         });
                       }
                     }
                  }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        )
      ),
    );
  }
}