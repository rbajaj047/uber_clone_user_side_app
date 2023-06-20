import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel
{
  String? status;
  String? fareAmount;
  String? originAddress;
  String? destinationAddress;
  String? time;
  String? carDetails;
  String? driverName;

  TripsHistoryModel({this.status, this.fareAmount, this.originAddress, this.destinationAddress, this.time, this.carDetails, this.driverName});

  TripsHistoryModel.fromSnapShot(DataSnapshot dataSnapshot)
  {
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    time = (dataSnapshot.value as Map)["time"];
    carDetails = (dataSnapshot.value as Map)["carDetails"];
    driverName = (dataSnapshot.value as Map)["driverName"];
  }

}