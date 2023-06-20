import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:http/http.dart' as http;
import '../infoHandler/app_info.dart';
import '../models/trips_history_model.dart';
import '../models/user_models.dart';

class AssistantMethods
{
  static Future<String> searchAddressForGeographicCoordinates(Position position, context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress="";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    if(requestResponse != "Error occurred, Failed, no response")
      {
        humanReadableAddress = requestResponse["results"][0]["formatted_address"];

        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = position.latitude;
        userPickUpAddress.locationLongitude = position.longitude;
        userPickUpAddress.locationName = humanReadableAddress;
        
        Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
      }

    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(currentFirebaseUser!.uid);
    
    userRef.once().then((snap) {
      if(snap.snapshot.value!=null)
        {
         userModelCurrentInfo  = UserModel.fromSnapshot(snap.snapshot);
         //print("User Name :" + userModelCurrentInfo!.name.toString());
         //print("User Email :" + userModelCurrentInfo!.email.toString());
        }
    });
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async
  {
    String? urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error occurred, Failed, no response")
      {
        return null;
      }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();

    directionDetailsInfo.ePoints = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distanceText = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distanceValue = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.durationText = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.durationValue = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;

  }

  static double calculateFareAmountFromSourceToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.durationValue! / 60)*7 ;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.durationValue! / 1000)*7 ;
    double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer ;

    return double.parse(totalFareAmount.toStringAsFixed(1)); // round off to 1 digit
  }

  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async
  {
    String destinationAddress = userDropOffAddress;
    
    Map<String, String> headerNotification = {
      'Content-Type':'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "body": "Destination Address: \n$destinationAddress",
      "title": "New Trip Request"
    };

    Map dataMap = {
      "click_action":"FLUTTER_NOTIFICATION_CLICK",
      "id":"1",
      "status":"done",
      "rideRequestId": userRideRequestId,
    };

    Map officialNotificationFormat = {
      "notification":bodyNotification,
      "data":dataMap,
      "priority":"high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat),
    );
  }


  //trip key = ride request keys
  static readTripKeysforOnlineUsers(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .orderByChild("userName")
        .equalTo(userModelCurrentInfo!.name)
        .once().then((snap){
          if(snap.snapshot.value!=null)
            {
              Map keysTripId = snap.snapshot.value as Map;
              int overallTripsCounter = keysTripId.length;

              //count total number of keys and share it with the provider
              Provider.of<AppInfo>(context, listen: false).updateOverallTripsCounter(overallTripsCounter);

              List<String> keysTripsList = [];
              keysTripId.forEach((key, value) {
                keysTripsList.add(key);
              });
              Provider.of<AppInfo>(context, listen: false).updateOverallTripsKeys(keysTripsList);

              readTripsHistoryInformation(context);
            }
    });
  }

  static readTripsHistoryInformation(context)
  {
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyKeysTripList;

    for(String eachKey in tripsAllKeys)
      {
        FirebaseDatabase.instance.ref()
            .child("All Ride Requests")
            .child(eachKey)
            .once().then((snap){
              var eachTripHistory = TripsHistoryModel.fromSnapShot(snap.snapshot);

              if((snap.snapshot.value as Map)["status"] == "ended") {
                Provider.of<AppInfo>(context, listen: false).updateOverallTripsHistoryInformation(eachTripHistory);
              }
        });
      }
  }

}