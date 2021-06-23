import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uber_rider_app/AllScreens/loginScreen.dart';
import 'package:flutter_uber_rider_app/AllScreens/mainscreen.dart';
import 'package:flutter_uber_rider_app/AllWidgets/progressDialog.dart';
import 'package:flutter_uber_rider_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatelessWidget {

  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
                  "Register as Rider",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                ),

                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 1.0),
                        TextFormField(
                          controller: nameTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Name",
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
                        SizedBox(height: 1.0),
                        TextFormField(
                          controller: phoneTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone",
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
                                child: Text("Create Account",
                                  style: TextStyle(
                                      fontSize: 18.0, fontFamily: "Brand Bold"),
                                )
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0),
                          ),
                          onPressed: () {
                            if (nameTextEditingController.text.length < 3) {
                              displayToastMessage("name must be at least 3 characters", context);
                            }
                            else if (!emailTextEditingController.text.contains("@")) {
                              displayToastMessage("email address is not valid",
                                  context);
                            } else if (phoneTextEditingController.text.isEmpty) {
                              displayToastMessage(
                                  "phone number is mandatory", context);
                            } else if (passwordTextEditingController.text.length <6) {
                              displayToastMessage(
                                  "password must be at least 6 characters",
                                  context);
                            }
                            registerNewUser(context);
                          },
                        )
                      ],
                    )
                ),

                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: Text(
                      "Alreday have an Account here? Login HERE"
                  ),)

              ],
            ),
          ),
        )
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return ProgressDialog(message: "registering, please wait");
        }
    );


    final User firebaseUser =
    (await _firebaseAuth.createUserWithEmailAndPassword(
    email: emailTextEditingController.text,
        password: passwordTextEditingController.text).
    catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;


    if( firebaseUser != null) //user created
       {
    //save user info to database
      userRef.child(firebaseUser.uid);
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("congratulations, your accout has been created", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
       }
  else {
displayToastMessage("New user account has not been Created", context);  }
}
}

  displayToastMessage(String message, BuildContext context) {

    Fluttertoast.showToast(msg: message);
  }
