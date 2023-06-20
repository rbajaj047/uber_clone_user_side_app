import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/widgets/info_design.dart';

class ProfileScreen extends StatefulWidget {


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                height: 2,
                thickness: 2,
                color: Colors.white,
              ),
            ),

            //name
            Text(
              userModelCurrentInfo!.name!,
              style:const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 50.0,
              ),
            ),

            const SizedBox(height: 38,),

            //phone
            InfoDesignUI(
              textInfo: userModelCurrentInfo!.phone,
              iconData: Icons.phone_iphone,
            ),

            //email
            InfoDesignUI(
              textInfo: userModelCurrentInfo!.email,
              iconData: Icons.email,
            ),

            const SizedBox(height: 20,),

            ElevatedButton(
                onPressed: ()
                {
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white54,
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
