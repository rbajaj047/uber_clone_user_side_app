import 'dart:async';
import 'package:flutter/material.dart';
import 'package:users_app/mainScreens/main_screen.dart';
import '../assistants/assistant_methods.dart';
import '../authentication/login_screen.dart';
import '../global/global.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer()
  {
    fAuth.currentUser!=null ? AssistantMethods.readCurrentOnlineUserInfo() : null;
    Timer(const Duration(seconds: 3), () async {
      //this is a callback function to send user to a specific screen
      //like signUp or signIn or home screen for example
      if(await fAuth.currentUser!= null)
        {
          currentFirebaseUser = fAuth.currentUser;
          Navigator.push(context, MaterialPageRoute(builder: (c) =>MainScreen()));
        }
      else
        {
          Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
        }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),

              const SizedBox(
                height: 14,
              ),

              const Text(
                "Uber & inDriver Clone App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//there is a default splash screen in flutter so do not use splash screen as class name
