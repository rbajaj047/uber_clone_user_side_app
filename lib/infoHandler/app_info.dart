/*import 'package:flutter/cupertino.dart';
import '../models/directions.dart';

class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }
}*/

import 'package:flutter/cupertino.dart';
import '../models/directions.dart';
import '../models/trips_history_model.dart';

class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation;
  Directions? userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyKeysTripList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];

  updateOverallTripsCounter(int overallTripsCounter)
  {
    countTotalTrips = overallTripsCounter;
    notifyListeners();
  }

  updateOverallTripsKeys(List<String> keysTripsList)
  {
    historyKeysTripList = keysTripsList;
    notifyListeners();
  }

  updateOverallTripsHistoryInformation(TripsHistoryModel eachTripHistory)
  {
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions userDropOffAddress)
  {
    userDropOffLocation = userDropOffAddress;
    notifyListeners();
  }
}