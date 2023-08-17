import 'package:flutter/material.dart';

Widget getStats(List<dynamic> stats){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: 10),
      Container(
        color: Colors.blue,
        width: 350.0,
        height: 20.0,
        child: Text("Stats", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
      ),
      for(var state in stats)
        Row(
          children: [
            SizedBox(
              width: 175,
              child: Text(
                "${state['stat']['name'].toString().toUpperCase()}: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.right
              ),
            ),
            SizedBox(
              width: 175,
              child: Text(state['base_stat'].toString()),
            ),
          ],
        )
    ],
  );
}