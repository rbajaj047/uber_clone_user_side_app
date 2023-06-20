import 'package:users_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

import 'infoHandler/app_info.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp(
    //child: ChangeNotifierProvider(
      //as our AppInfo class is linked with the provider state management, that's why we use changeNotifierProvider
      //create: (context) => AppInfo(),
      //as our AppInfo class provides data, it is a provideHandler basically, which provides data throughout our app.
      //In order to make it work and provide data throughout our user app, we have to provide the access to our appInfo class.
      child: ChangeNotifierProvider(
        create: (context) => AppInfo(),
        child: MaterialApp(
          title: 'Users App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MySplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  //),
  );
}

class MyApp extends StatefulWidget
{
  final Widget? child;// the ? stands for null safety
  MyApp({this.child});

  static void restartApp(BuildContext context)
  {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
    //this function will be called whenever we will restart our app

  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Key key = UniqueKey();
  void restartApp()
  {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {

    return KeyedSubtree(
        key: key,
        child: widget.child!);//the ! stands for null safety

  }
}

