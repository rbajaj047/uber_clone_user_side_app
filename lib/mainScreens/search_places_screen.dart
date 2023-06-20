import 'package:flutter/material.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/mainScreens/main_screen.dart';

import '../global/map_key.dart';
import '../models/predicted_places.dart';
import '../widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  @override

  List<PredictedPlaces> placePredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async
  {
    if(inputText.length > 1)
      {
        String urlAutoCompleteSearch="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:IN";
        var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

        if(responseAutoCompleteSearch == "Error occurred, Failed, no response")
          {
            return;
          }

        if(responseAutoCompleteSearch["status"] == "OK")
          {
            var placePredictions = responseAutoCompleteSearch["predictions"];
            //json type ka data ko list mey convert krke placePredictionList mey store krlia h
            var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();
            //ye variable method k andar bana h
            //class k bahar access krne k liye ek list bnaya h placePredictedList

            setState(() {
              placePredictedList = placePredictionsList;
            });
          }
      }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //search place ui
          Container(
            height: 160,
            decoration:const BoxDecoration(
              color: Colors.black54,
              boxShadow: [BoxShadow(
                color: Colors.white54,
                blurRadius: 8,
                spreadRadius: 0.5,
                offset: Offset(0.7,0.7),
              ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const SizedBox(height: 25,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:()
                        {
                          Navigator.pop(context);
                        },
                        child:const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Search and Set drop-off location",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 18,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TextField(
                            onChanged: (valueTyped)
                            {
                              findPlaceAutoCompleteSearch(valueTyped);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search here...",
                              fillColor: Colors.white54,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //display place prediction result
          (placePredictedList.length > 0)
              ? Expanded(
                    child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context,index)
                        {
                          return PlacePredictionTileDesign(
                            predictedPlaces: placePredictedList[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index)
                        {
                          return const Divider(
                            height: 1,
                            color: Colors.white,
                            thickness: 1,
                          );
                        },
                        itemCount: placePredictedList.length,
                    )
                )
              :Container(),
        ],
      ),
    );
  }
}
/**/
/*Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            //margin:const EdgeInsets.fromLTRB(0, 0, 0, 0),
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Icon(icon)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );*/
