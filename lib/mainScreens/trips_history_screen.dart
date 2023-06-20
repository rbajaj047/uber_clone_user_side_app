import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:users_app/widgets/history_design_ui.dart';

import '../infoHandler/app_info.dart';

class TripsHistoryScreen extends StatefulWidget {


  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          "History",
          //style: TextStyle(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close,),
          onPressed: (){
            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, i)=>
          const Divider(
            color: Colors.black54,
            height: 2,
            thickness: 2,
          ),

        itemBuilder: (context, i){
        return Card(
          color: Colors.black12,
          child: HistoryDesignUIWidget(
              tripsHistoryModel: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList[i],
            ),
        );
        },
        itemCount: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,

      ),
    );
  }
}
