import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/assistants/geofire_assistant.dart';
import 'package:users_app/main.dart';
import 'package:users_app/mainScreens/rate_driver_screen.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/mainScreens/search_places_screen.dart';
import 'package:users_app/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/widgets/my_drawer.dart';
import 'package:users_app/widgets/pay_fare_amount_dialog.dart';
import 'package:users_app/widgets/progress_dialog.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import '../authentication/login_screen.dart';
import '../global/global.dart';
import '../infoHandler/app_info.dart';
import '../models/active_nearby_available_drivers.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220.0;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoOrdinateList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "Your Name";
  String userEmail = "Your Email";
  bool openNavigationDrawer = true;
  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor?activeNearbyIcon;

  List<ActiveNearbyAvailableDrivers> onlineNearbyAvailableDriversList =[];

  DatabaseReference? referenceRideRequest;
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;
  String userRideRequestStatus = "";
  bool requestPositionInfo = true;



  blackThemeGoogleMap() {
    //for black theme
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //the above line of code gives the position of the user with high accuracy
    userCurrentPosition = cPosition;

    //convert position into latitude and longitude
    LatLng latLngPosition = LatLng(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    //adjust camera so that it adjusts when user moves
    CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(userCurrentPosition!, context);

    //print("this is your address = $humanReadableAddress");

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeofireListener();
    //String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(userCurrentPosition!,context);

    AssistantMethods.readTripKeysforOnlineUsers(context);
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  saveRideRequestInformation()
  {
    //1. save the ride request Information
    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Requests").push();
    //every ride request will have their unique id that is the function of ".push()" in the previous line
    //.push() generates a unique id
    
    var originLocation = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    //we have to get separately the latitude and longitude of the source/origin location and that of the destination location
    //for that we are creating a map

    Map originLocationMap =
    {
      //key:value
      "latitude" : originLocation!.locationLatitude.toString(),
      "longitude" : originLocation!.locationLongitude.toString(),
    };
    Map destinationLocationMap =
    {
      //key:value
      "latitude" : destinationLocation!.locationLatitude.toString(),
      "longitude" : destinationLocation!.locationLongitude.toString(),
    };
    Map userInformationMap =
    {
      //key:value
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time":DateTime.now().toString(),
      "userName":userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
      //by default the driverId is waiting. When the driver will be assigned, we will edit the driverId then
    };

    referenceRideRequest!.set(userInformationMap);
    tripRideRequestInfoStreamSubscription = referenceRideRequest!.onValue.listen((eventsnap) async {
      if(eventsnap.snapshot.value == null){
        return;
      }
          if((eventsnap.snapshot.value as Map)["car_details"] != null) {
            setState(() {
              driverCarDetails =
                  (eventsnap.snapshot.value as Map)["car_details"].toString();
            });}

          if((eventsnap.snapshot.value as Map)["driverPhone"] != null) {
            setState(() {
              driverPhone =
                  (eventsnap.snapshot.value as Map)["driverPhone"].toString();
            });}
          if((eventsnap.snapshot.value as Map)["driverName"] != null) {
            setState(() {
              driverName =
                  (eventsnap.snapshot.value as Map)["driverName"].toString();
            });}

          if( (eventsnap.snapshot.value as Map)["status"] != null )
          {
            userRideRequestStatus = (eventsnap.snapshot.value as Map)["status"].toString() ;
            //status=accepted

          }

          if( (eventsnap.snapshot.value as Map)["driverLocation"] != null )
          {
            double driverCurrentPositionLat = double.parse((eventsnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
            double driverCurrentPositionLng = double.parse((eventsnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

            LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

            if(userRideRequestStatus == "accepted")
            {
              updateArrivalTimeToUserPickUp(driverCurrentPositionLatLng);
            }

            //status=arrived
            if(userRideRequestStatus == "arrived")
            {
              setState(() {
                driverRideStatus = "Driver has arrived.";
              });
            }

            //status=ontrip
            if(userRideRequestStatus == "ontrip")
            {
              updateReachingTimeToUserDropOff(driverCurrentPositionLatLng);
            }

            //status=ended
            if(userRideRequestStatus == "ended")
            {
              if( (eventsnap.snapshot.value as Map)["fareAmount"] != null )
                {
                  double fareAmount = double.parse((eventsnap.snapshot.value as Map)["fareAmount"].toString());

                  var response = await showDialog(context: context, barrierDismissible: false, builder: (BuildContext c)=>PayFareAmountDialog(fareAmount:fareAmount));

                  if(response=="cashPayed")
                    {
                      //user can rate the driver now
                      if( (eventsnap.snapshot.value as Map)["driverId"] != null )
                        {
                          String assignedDriverId = (eventsnap.snapshot.value as Map)["driverId"].toString();
                          
                          Navigator.push(context, MaterialPageRoute(builder: (c)=>RateDriverScreen(assignedDriverId: assignedDriverId)));

                          referenceRideRequest!.onDisconnect();
                          tripRideRequestInfoStreamSubscription!.cancel();
                        }
                    }
                }
            }
          }


    });

    onlineNearbyAvailableDriversList = GeofireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  updateArrivalTimeToUserPickUp(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
      {
        requestPositionInfo = false;
        LatLng userPickUpPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

        var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(driverCurrentPositionLatLng, userPickUpPosition);

        if(directionDetailsInfo == null)
          {
            return;
          }
        setState(() {
          driverRideStatus = "Driver is Coming :: ${directionDetailsInfo.durationText}";
        });
        requestPositionInfo = true;
      }
  }

  updateReachingTimeToUserDropOff(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
    {
      requestPositionInfo = false;
      var dropOffLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
      LatLng userDestinationPosition = LatLng(dropOffLocation!.locationLatitude!, dropOffLocation.locationLongitude!);

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(driverCurrentPositionLatLng, userDestinationPosition);

      if(directionDetailsInfo == null)
      {
        return;
      }
      setState(() {
        driverRideStatus = "Going towards Destination :: ${directionDetailsInfo.durationText}";
      });
      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async
  {
    if(onlineNearbyAvailableDriversList.isEmpty)
      {
        //2. cancel the ride request Information
        referenceRideRequest!.remove();
        setState(() {
          polyLineSet.clear();
          markersSet.clear();
          circlesSet.clear();
          pLineCoOrdinateList.clear();

        });
        Fluttertoast.showToast(msg: "No Online Nearest Driver Available.");
        Fluttertoast.showToast(msg: "Restarting App now, search again after sometime");

        Future.delayed(const Duration(milliseconds: 4000),()
        {
          SystemNavigator.pop();
        });

        return;
      }
    await retrieveOnlineDriversInformation(onlineNearbyAvailableDriversList);
    // ignore: use_build_context_synchronously
    var response = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SelectNearestActiveDriverScreen(referenceRideRequest : referenceRideRequest)));

    if(response == "driverChoosed")
      {
        FirebaseDatabase.instance.ref().child("drivers").child(chosenDriverId!).once().then((snap) =>
        {
          if(snap.snapshot.value != null)
            {
              //send notification to that specific driver
              sendNotificationToDriverNow(chosenDriverId!)
            }
          else
            {
              Fluttertoast.showToast(msg: "This driver does not exist. Try again.")
            }
        });
      }
  }

  sendNotificationToDriverNow(String chosenDriverId)
  {
    //assign rideRequestId to newRideStatus in Driver's parent node for that specific chosen driver
    FirebaseDatabase.instance.ref().child("drivers").child(chosenDriverId).child("newRideStatus").set(referenceRideRequest!.key);
    //automate the push notification
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once().then((snap){
          if(snap.snapshot.value != null)
            {
              String deviceRegistrationToken = snap.snapshot.value.toString();

              //send notification now
              AssistantMethods.sendNotificationToDriverNow(deviceRegistrationToken, referenceRideRequest!.key.toString(), context);

              //waiting response from the driver UI
              showWaitingResponseFromDriver();

              FirebaseDatabase.instance.ref()
                  .child("drivers")
                  .child(chosenDriverId).child("newRideStatus").onValue.listen((eventSnapshot){

                //cancel the rideRequest push notification
                //newRideStatus becomes idle
                if(eventSnapshot.snapshot.value == "idle"){
                  Fluttertoast.showToast(msg: "The driver has cancelled your request. Please choose another driver.");
                  Future.delayed(
                      const Duration(milliseconds: 3000),
                        (){
                        Fluttertoast.showToast(msg: "Please restart app now");
                        SystemNavigator.pop();
                      });
                }


                //accept the rideRequest push notification
                //newRideStatus becomes accepted
                if(eventSnapshot.snapshot.value == "accepted"){
                  //design and display UI displaying driver info
                  showUIForAssignedDriverInfo();
                }
                  });


            }
          else
            {
              Fluttertoast.showToast(msg: "Please choose another driver.");
              return;
            }
    });
  }

  showUIForAssignedDriverInfo()
  {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 0;
      assignedDriverInfoContainerHeight = 250;

    });
  }

  showWaitingResponseFromDriver()
  {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 220;

    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async
  {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for(int i=0;i<onlineNearestDriversList.length;i++)
      {
        await ref.child(onlineNearestDriversList[i].key.toString())
            .once()
            .then((dataSnapshot){
              var driverKeyInfo = dataSnapshot.snapshot.value;
              dList.add(driverKeyInfo);
        });
      }
  }

  @override
  Widget build(BuildContext context) {

    createActiveNearbyDriverIconMarker();

    return Scaffold(
      key: sKey,
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(name: userName, email: userEmail,)),
      body: Stack(
        children: [
          GoogleMap(
            //padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 240;
              });

              locateUserPosition();
            },
          ),

          //custom hamburger button
          Positioned(
            top: 36,
            left: 22,
            child: GestureDetector(
              onTap: () {
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                }
                else {
                  //restarts the app and basically refreshes it
                  SystemNavigator.pop();
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.black,
                  weight: 20.0,
                ),
              ),
            ),
          ),

          //UI for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      //from
                      Row(
                        children: [
                          Icon(Icons.add_location_alt_outlined,
                            color: Colors.grey,),
                          const SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From", style: TextStyle(color: Colors.grey),),
                              Text(
                                Provider
                                    .of<AppInfo>(context)
                                    .userPickUpLocation != null
                                    ? (Provider
                                    .of<AppInfo>(context)
                                    .userPickUpLocation!
                                    .locationName!).substring(0, 26) + "..."
                                    : "your current location",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              /*Text(
                                Provider.of<AppInfo>(context).userPickUpLocation!=null
                                ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName! : "your current location",
                                style: const TextStyle(color: Colors.grey),),*/
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10.0,),
                      //to
                      GestureDetector(
                        onTap: () async
                        {
                          var responseFromSearchScreen = await Navigator.push(
                              context, MaterialPageRoute(
                              builder: (c) => SearchPlacesScreen()));
                          if (responseFromSearchScreen == "obtainedDropoff") {
                            setState(() {
                              openNavigationDrawer = false;
                            });

                            //draw routes/poly-lines
                            await drawPolylineFromSourceToDestination();
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add_location_alt_outlined,
                              color: Colors.grey,),
                            const SizedBox(width: 12.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "To", style: TextStyle(color: Colors.grey),),
                                Text(
                                  Provider
                                      .of<AppInfo>(context)
                                      .userDropOffLocation != null
                                      ? Provider
                                      .of<AppInfo>(context)
                                      .userDropOffLocation!
                                      .locationName!
                                      : "where to go",
                                  style: TextStyle(color: Colors.grey),),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10.0,),
                      ElevatedButton(
                        onPressed: ()
                        {
                          if(Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null)
                            {
                              saveRideRequestInformation();
                            }
                          else
                            {
                              Fluttertoast.showToast(msg: "Please select destination location");

                            }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,

                            )
                        ),
                        child: const Text("Request a Ride",),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //UI for driver response container
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: waitingResponseFromDriverContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText(
                          'Waiting for response\nfrom driver',
                          duration: const Duration(seconds: 3,),
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        ScaleAnimatedText(
                          'Please Wait...',
                          duration: const Duration(seconds: 4,),
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(fontSize: 72.0, color: Colors.white, fontFamily: 'Canterbury'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ),

          //UI for displaying assigned driver info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
              child: Container(
                height: assignedDriverInfoContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //status of ride
                      Center(
                        child: Text(
                          driverRideStatus,
                          //textAlign: TextAlign.center,//cross axis alignment k wajh se ye kaam nhi krega
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Divider(height: 2, thickness: 2, color: Colors.white54,),
                      const SizedBox(height: 20,),
                      //driver vehicle details
                      Text(
                        driverCarDetails,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(height: 2,),

                      //driver details
                      Text(
                        driverName!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(height: 20,),
                      const Divider(height: 2, thickness: 2, color: Colors.white54,),
                      const SizedBox(height: 20,),

                      //call driver button
                      Center(
                        child: ElevatedButton.icon(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green,),
                            icon: const Icon(Icons.phone_android, color: Colors.black54, size: 22,),
                            label: const Text("Call Driver",
                              style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              ),
                            ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Future<void> drawPolylineFromSourceToDestination() async
  {
    var sourcePosition = Provider
        .of<AppInfo>(context, listen: false)
        .userPickUpLocation;
    var destinationPosition = Provider
        .of<AppInfo>(context, listen: false)
        .userDropOffLocation;

    var sourceLatLng = LatLng(
        sourcePosition!.locationLatitude!, sourcePosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition!.locationLongitude!);

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Please wait...",)
    );

    var directionDetailsInfo = await AssistantMethods
        .obtainOriginToDestinationDirectionDetails(
        sourceLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    //print("These are points : ");
    //print(directionDetailsInfo!.ePoints);

    PolylinePoints pPoints = PolylinePoints();

    List<PointLatLng> decodedPolylinePointsResultList = pPoints.decodePolyline(
        directionDetailsInfo!.ePoints!);
    //we can accept a list of LatLng points only for drawing polyline so the above list needs to be decoded from PointsLatLng to just LatLng
    //hence we will run a loop and do the necessary conversion

    pLineCoOrdinateList.clear();

    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinateList.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      //polyLineSet.clear();
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(polylineId: const PolylineId("PolylineId"),
          color: Colors.indigo,
          jointType: JointType.round,
          points: pLineCoOrdinateList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (sourceLatLng.latitude > destinationLatLng.latitude &&
        sourceLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: destinationLatLng,
        northeast: sourceLatLng,
      );
    }
    else if (sourceLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(sourceLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, sourceLatLng.longitude),
      );
    }
    else if (sourceLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, sourceLatLng.longitude),
        northeast: LatLng(sourceLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else {
      boundsLatLng = LatLngBounds(
        southwest: sourceLatLng,
        northeast: destinationLatLng,
      );
    }

    newGoogleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker sourceMarker = Marker(
      markerId: const MarkerId("sourceID"),
      infoWindow: InfoWindow(
        title: sourcePosition.locationName,
        snippet: "Origin",
      ),
      position: sourceLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
        title: destinationPosition.locationName,
        snippet: "Destination",
      ),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markersSet.add(sourceMarker);
      markersSet.add(destinationMarker);
    });

    Circle sourceCircle = Circle(
      circleId: const CircleId("sourceID"),
      center: sourceLatLng,
      fillColor: Colors.green,
      radius: 12,
      strokeColor: Colors.white70,
      strokeWidth: 3,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      center: destinationLatLng,
      fillColor: Colors.orangeAccent,
      radius: 12,
      strokeColor: Colors.white70,
      strokeWidth: 3,
    );

    setState(() {
      circlesSet.add(sourceCircle);
      circlesSet.add(destinationCircle);
    });
  }

  initializeGeofireListener() {
    Geofire.initialize("activeDrivers");
    //if any driver becomes online then it will display them
    //5 represents the distance in kilometers

    Geofire.queryAtLocation(userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!.listen((map) {
      //print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered: //whenever any driver become active/online
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeofireAssistant.activeNearbyAvailableDriversList.add(activeNearbyAvailableDriver);
            if(activeNearbyDriverKeysLoaded == true)
              {
                displayActiveDriversOnUsersMap();
              }
            break;

          case Geofire.onKeyExited: //whenever any driver become non-active/offline
            GeofireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

          case Geofire.onKeyMoved: //whenever driver moves - update driver location
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeofireAssistant.updateActiveNearbyAvailableDriverLocation(activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;

          case Geofire.onGeoQueryReady: //display those online active drivers
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap()
  {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();
      for(ActiveNearbyAvailableDrivers eachDriver in GeofireAssistant.activeNearbyAvailableDriversList)
        {
          LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

          Marker marker = Marker(
            markerId: MarkerId(eachDriver.driverId!),
            position: eachDriverActivePosition,
            icon: activeNearbyIcon!,
            rotation: 360,
          );

          driversMarkerSet.add(marker);
        }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  createActiveNearbyDriverIconMarker()
  {
    if(activeNearbyIcon == null)
      {
        ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
        BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png").then((value)
        {
          activeNearbyIcon = value;
        });
      }
  }
}
