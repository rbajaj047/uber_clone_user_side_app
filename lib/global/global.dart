import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/user_models.dart';

import '../models/direction_details_info.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;

User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //driverKeys Info List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
String cloudMessagingServerToken = "key=AAAAkxhAT4E:APA91bFU0g6HGtIypCob8cjGCNzKk52XzyCOp7kHl_ZhfCa5d3Mb6EAp6q2wuD-Bh372_z6YViEiJSdUUGiTA5iA3_WX3lFXgr1p3hpWg8moGHKBGCLIHj2DHfKDTmvm6K-C7FbTJ70W";
String userDropOffAddress = "";
String driverRideStatus = "Driver is Coming";
String driverCarDetails = "";
String? driverPhone = "";
String driverName = "";
double countRatingStars = 0.0;
String titleStarsRating = "";