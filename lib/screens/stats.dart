import 'package:flutter/material.dart';

Widget getStats(List<dynamic> stats){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: 10),
      Text("Stats", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      for(var state in stats)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(state['stat']['name'].toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text(state['base_stat'].toString()),
          ],
        )
    ],
  );
}