import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uber_rider_app/AllScreens/loginScreen.dart';
import 'package:flutter_uber_rider_app/AllScreens/mainscreen.dart';
import 'package:flutter_uber_rider_app/AllScreens/registrationScreen.dart';
import 'package:flutter_uber_rider_app/DataHandler/appData.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {

  static const String idScreen = "register";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>AppData(), //initialize changenotifier
      child: MaterialApp(
          title: 'taxi rider app',
          theme: ThemeData(
            fontFamily: "Signatra",
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: MainScreen.idScreen,
        routes:
            {
              RegistrationScreen.idScreen: (context) =>RegistrationScreen(),
              LoginScreen.idScreen: (context) =>LoginScreen(),
              MainScreen.idScreen: (context) =>MainScreen(),
            },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}