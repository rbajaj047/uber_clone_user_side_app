import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global.dart';

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;
  RateDriverScreen({this.assignedDriverId});
  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}




class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.white54,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 22,),
              const Text(
                "Rate Trip Experience",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 22,),
              const Divider(height: 4, thickness: 4,),
              const SizedBox(height: 22,),

              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: true,
                starCount: 5,
                size: 46,
                color: Colors.green,
                onRatingChanged: (valueOfStarsChoosed){
                  countRatingStars = valueOfStarsChoosed;

                  if(countRatingStars == 1)
                  {
                    titleStarsRating = "Very Bad";
                  }

                  if(countRatingStars == 1)
                  {
                    titleStarsRating = "Bad";
                  }

                  if(countRatingStars == 1)
                  {
                    titleStarsRating = "Okay";
                  }

                  if(countRatingStars == 1)
                  {
                    titleStarsRating = "Very Good";
                  }

                  if(countRatingStars == 1)
                  {
                    titleStarsRating = "Excellent";
                  }
                },
              ),
              const SizedBox(height: 22,),
              
              Text(
                titleStarsRating,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18,),

              ElevatedButton(
                onPressed: ()
                {
                  DatabaseReference rateDriverRef = FirebaseDatabase.instance.ref()
                      .child("drivers")
                      .child(widget.assignedDriverId!)
                      .child("ratings");
                  rateDriverRef.once().then((snap){
                    if(snap.snapshot.value !=null)
                      {
                        rateDriverRef.set(countRatingStars.toString());
                        Fluttertoast.showToast(msg: "Thank You! Restarting app now!");
                        SystemNavigator.pop();
                      }
                    else
                      {
                        double pastRatings = double.parse(snap.snapshot.value.toString());
                        double newAverageRatings = (pastRatings+countRatingStars)/2;
                        rateDriverRef.set(newAverageRatings.toString());
                        Fluttertoast.showToast(msg: "Thank You! Restarting app now!");
                        SystemNavigator.pop();
                      }
                  });

                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 58,),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18,),
            ],
          ),
        ),
      ),
    );
  }
}
