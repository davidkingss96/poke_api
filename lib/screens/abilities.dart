import 'package:flutter/material.dart';

import '../services/pokemon_services.dart';

final PokemonServices pokemonService = PokemonServices();

Widget getAbilities(BuildContext context, List<dynamic> abilitiesList) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        width: 350.0,
        height: 20.0,
        child: Text("Abilities", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for(var ability in abilitiesList)
            SizedBox(
              height: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () => _navigateToAbilityInfo(context, ability['ability']),
                child: Text(ability['ability']['name'], style: TextStyle(color: Colors.white),),
              ),
            )
        ],
      )
    ],
  );
}

void _navigateToAbilityInfo(BuildContext context, Map<String, dynamic> ability) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(ability['name'].toString().toUpperCase()),
        content: extendsAbilityInfo(ability),
      );
    },
  );
}

Widget extendsAbilityInfo(Map<String, dynamic> ability) {
  return FutureBuilder<Map<String, dynamic>>(
    future: pokemonService.getData(ability['url']),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator()
          ],
        );
      } else if (snapshot.hasError) {
        return Text('Error');
      } else if (snapshot.hasData) {
        final abilityData = snapshot.data!;
        String? effect;
        for(var effectEntry in abilityData['effect_entries']){
          if(effectEntry['language']['name'] == "en"){
            effect = effectEntry['effect'];
          }
        }
        return Text(effect!);
      } else {
        return Text('No data');
      }
    },
  );
}