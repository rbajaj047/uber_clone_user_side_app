import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/assistants/assistant_methods.dart';

import '../global/global.dart';

class SelectNearestActiveDriverScreen extends StatefulWidget {
  DatabaseReference? referenceRideRequest;
  SelectNearestActiveDriverScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriverScreen> createState() => _SelectNearestActiveDriverScreenState();
}

class _SelectNearestActiveDriverScreenState extends State<SelectNearestActiveDriverScreen> {

  String fareAmount="";
  getFareAmountAccordingToVehicleType(int index)
  {
    if(tripDirectionDetailsInfo!=null)
      {
        if(dList[index]["car-details"]["type"].toString() == "bike")
          {
            fareAmount = (AssistantMethods.calculateFareAmountFromSourceToDestination(tripDirectionDetailsInfo!)/2).toStringAsFixed(1);
          }
        if(dList[index]["car-details"]["type"].toString() == "uber-x") //more spacious, more comfortable
        {
          fareAmount = (AssistantMethods.calculateFareAmountFromSourceToDestination(tripDirectionDetailsInfo!)).toStringAsFixed(1);
        }
        if(dList[index]["car-details"]["type"].toString() == "uber-go")
        {
          fareAmount = (AssistantMethods.calculateFareAmountFromSourceToDestination(tripDirectionDetailsInfo!)*2).toString();
        }
      }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white54,
          title: const Text(
            "Nearest Online Drivers",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close, color: Colors.white,),
            onPressed: (){
              //remove ride request from database
              widget.referenceRideRequest!.remove();
              Fluttertoast.showToast(msg: "You have cancelled the ride request.");
              SystemNavigator.pop();
            },
          ),
        ),
        body: ListView.builder(
              itemCount: dList.length,
              itemBuilder: (BuildContext context, int index)
              {
              return GestureDetector(
                onTap: ()
                {
                  setState(() {
                    chosenDriverId = dList[index]["id"].toString();
                  });
                  Navigator.pop(context, "driverChoosed");
                },
                child: Card(
                    color: Colors.grey,
                    elevation: 3,
                    shadowColor: Colors.green,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Image.asset(
                          "images/"+ dList[index]["car-details"]["type"].toString() + ".png",
                          width: 70,
                      ),
                    ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            dList[index]["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            dList[index]["car_details"]["car_model"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                          SmoothStarRating(
                            rating: 3.5,
                            color: Colors.black,
                            borderColor: Colors.black,
                            allowHalfRating: true,
                            starCount: 5,
                            size: 15,
                          )
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rs. "+ getFareAmountAccordingToVehicleType(index),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2,),
                          Text(
                            tripDirectionDetailsInfo!=null ? tripDirectionDetailsInfo!.distanceText! : "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
              );
            },
      ),
    );
  }
}
