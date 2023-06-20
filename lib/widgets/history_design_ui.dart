import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/models/trips_history_model.dart';

class HistoryDesignUIWidget extends StatefulWidget {

  TripsHistoryModel? tripsHistoryModel;
  HistoryDesignUIWidget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}

class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget> {

  String formatDateTime(String dateTimeFromDB)
  {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);
    String formattedDateTime = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)}, ${DateFormat.jm().format(dateTime)}";
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18, vertical: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //driver details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //driverName
                Padding(
                  padding: const EdgeInsets.only(left: 6.0,),
                  child: Text(
                    "Driver: ${widget.tripsHistoryModel!.driverName!}",
                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12,),

                //fareAmount
                Text(
                  "Rs.${widget.tripsHistoryModel!.fareAmount!}",
                  style:
                  const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2,),

            //car details
            Row(
              children: [
                //driverName
                const Icon(
                  Icons.car_repair,
                  color: Colors.black,
                  size: 28,
                ),

                const SizedBox(width: 12,),

                //fareAmount
                Text(
                  widget.tripsHistoryModel!.carDetails!,
                  style:
                  const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),

            //pick-up details
            Row(
                  children: [
                    Image.asset(
                      "images/origin.png",
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.tripsHistoryModel!.originAddress!,
                          overflow: TextOverflow.ellipsis,
                          style:
                          const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

            const SizedBox(height: 14,),

            //drop-off details
            Row(
                  children: [
                    Image.asset(
                      "images/destination.png",
                      height: 23,
                      width: 23,
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Text(
                        widget.tripsHistoryModel!.destinationAddress!,
                        overflow: TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),

                  ],
                ),
            
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "",
                ),
                Text(
                  formatDateTime(widget.tripsHistoryModel!.time!),
                  style: const TextStyle(
                    color: Colors.grey
                  ),
                ),
              ],
            ),

            const SizedBox(height: 3,),

          ],
        ),
      ),
    );
  }
}
