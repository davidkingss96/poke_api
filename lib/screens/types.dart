import 'package:flutter/material.dart';

import '../services/pokemon_services.dart';

final PokemonServices pokemonService = PokemonServices();

Widget getTypes(BuildContext context, List<dynamic> types) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: 10),
      Container(
        color: Colors.blue,
        width: 250.0,
        height: 20.0,
        child: Text("Types", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for(var type in types)
            SizedBox(
              height: 25,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => damageRelations(type['type'])),
                  );
                },
                child: Text(type['type']['name'].toString().toUpperCase()),
              ),
            )
        ],
      )
    ],
  );
}

Widget damageRelations(Map<String, dynamic> type){
  return FutureBuilder<Map<String, dynamic>>(
    future: pokemonService.getData(type['url']),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Text('Error');
      } else if (snapshot.hasData) {
        final typeData = snapshot.data!;
        final damageRelations = typeData["damage_relations"];
        return Scaffold(
            appBar: AppBar(title: Text("TYPE ${type['name']}".toUpperCase())),
            body: ListView(
              children: [
                ExpansionTile(
                  title: Text("Double Damage From"),
                  children: [
                    for(var damageType in damageRelations["double_damage_from"])
                      ListTile(
                          title: ElevatedButton(
                            onPressed: () {
                              print(damageType);
                              print(type);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => damageRelations(damageType)),
                              // );
                            },
                            child: Text(damageType["name"].toString().toUpperCase()),
                          )
                      ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Double Damage To"),
                  children: [
                    for (var damageType in damageRelations["double_damage_to"])
                      ListTile(
                        title: Text(damageType["name"]),
                      ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Half Damage From"),
                  children: [
                    for (var damageType in damageRelations["half_damage_from"])
                      ListTile(
                        title: Text(damageType["name"]),
                      ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Half Damage To"),
                  children: [
                    for (var damageType in damageRelations["half_damage_to"])
                      ListTile(
                        title: Text(damageType["name"]),
                      ),
                  ],
                ),
                ExpansionTile(
                  title: Text("No Damage From"),
                  children: [
                    for (var damageType in damageRelations["no_damage_from"])
                      ListTile(
                        title: Text(damageType["name"]),
                      ),
                  ],
                ),
                ExpansionTile(
                  title: Text("No Damage To"),
                  children: [
                    for (var damageType in damageRelations["no_damage_to"])
                      ListTile(
                        title: Text(damageType["name"]),
                      ),
                  ],
                ),
              ],
            )
        );
      }
      return Text('No data');
    },
  );
}