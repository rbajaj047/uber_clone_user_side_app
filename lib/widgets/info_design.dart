import 'package:flutter/material.dart';

class InfoDesignUI extends StatefulWidget {

  String? textInfo;
  IconData? iconData;

  InfoDesignUI({this.iconData, this.textInfo});

  @override
  State<InfoDesignUI> createState() => _InfoDesignUIState();
}

class _InfoDesignUIState extends State<InfoDesignUI> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.black,
        ),
        title: Text(
          widget.textInfo!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
