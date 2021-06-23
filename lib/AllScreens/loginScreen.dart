import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uber_rider_app/AllScreens/registrationScreen.dart';
import 'package:flutter_uber_rider_app/AllWidgets/progressDialog.dart';
import 'package:flutter_uber_rider_app/main.dart';

import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {

  static const String idScreen = "Login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 35.0),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 390.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),
                SizedBox(height: 1.0),
                Text(
                  "Login as Rider",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                ),

                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 1.0),
                        TextFormField(
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),

                        TextFormField(
                          controller: passwordTextEditingController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: TextStyle(height: 1.0),
                        ),
                        SizedBox(height: 20.0),

                        RaisedButton(
                          color: Colors.yellow,
                          textColor: Colors.white,
                          child: Container(
                            height: 50.0,
                            child: Center(
                                child: Text("login",
                                  style: TextStyle(
                                      fontSize: 18.0, fontFamily: "Brand Bold"),
                                )
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0),
                          ),
                          onPressed: () {

                            if (!emailTextEditingController.text.contains("@")) {
                              displayToastMessage("email address is not valid",
                                  context);
                            }

                            else if (passwordTextEditingController.text.isEmpty) {
                              displayToastMessage(
                                  "password is mandatory",
                                  context);
                            }
                            else {
                              loginAndAuthenticateUser(context);
                            }
                          },
                        )
                      ],
                    )
                ),

                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.idScreen, (route) => false);
                  },
                  child: Text(
                      "Do not have an account? register here"
                  ),)

              ],
            ),
          ),
        )
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    
    showDialog(
      context: context,
    barrierDismissible: false,
    builder: (BuildContext context){

       return ProgressDialog(message: "authenticating, please wait");
    }
    );
    
    final User firebaseUser =
        (await _firebaseAuth.signInWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text).
        catchError((errMsg) {
          Navigator.pop(context);
          displayToastMessage("Error: " + errMsg.toString(), context);
        })).user;


    if (firebaseUser != null) //user created
        {
      //save user info to database

      userRef.child(firebaseUser.uid).once().then(
          (DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("You are logged in", context);
        }
        else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage(
              "no record for this user. please create new account", context);
        }
      });
    }
    else {
      Navigator.pop(context);
      displayToastMessage("error occurred", context);
    }
  }
}

      
