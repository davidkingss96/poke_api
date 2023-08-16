import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../services/pokemon_services.dart';

class PokemonTile {
  final PokemonServices pokemonService = PokemonServices();

  Widget buildPokemonTile(Map<String, dynamic> pokemon){
    return FutureBuilder<Map<String, dynamic>>(
      future: pokemonService.getData(pokemon['url']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        } else if (snapshot.hasError) {
          return Text('Error');
        } else if (snapshot.hasData) {
          final pokemonData = snapshot.data!;
          final pokemonName = pokemonData['name'].toString().toUpperCase();
          String? typeDesc;
          for(var type in pokemonData['types']){
            typeDesc = typeDesc != null ? "$typeDesc, ${type['type']['name']}" : type['type']['name'];
          }
          final urlImage = pokemonData['sprites']['other']['dream_world']['front_default'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.network(urlImage, width: 90, height: 90,),
              Text(pokemonName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                children: [
                  Text(typeDesc!),
                ],
              )
            ],
          );
        } else {
          return Text('No data');
        }
      },
    );
  }

  Widget extendsPokemonInfo(Map<String, dynamic> pokemon) {
    return FutureBuilder<Map<String, dynamic>>(
      future: pokemonService.getData(pokemon['url']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error');
        } else if (snapshot.hasData) {
          final pokemonData = snapshot.data!;
          final pokemonName = pokemonData['name'].toString().toUpperCase();
          final pokemonHeight = pokemonData['height'];
          final pokemonWeight = pokemonData['weight'];
          final urlImage = pokemonData['sprites']['other']['dream_world']['front_default'];
          final List abilities = pokemonData['abilities'];
          final List stats = pokemonData['stats'];
          final List types = pokemonData['types'];

          return Scaffold(
            appBar: AppBar(title: Text("POKEMON $pokemonName")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(pokemonName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SvgPicture.network(urlImage, width: 90, height: 90,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Height: $pokemonHeight'),
                      SizedBox(width: 30),
                      Text('Weight: $pokemonWeight'),
                    ],
                  ),
                  SizedBox(height: 10),
                  getAbilities(context, abilities),
                  getTypes(context, types),
                  getStats(stats),
                ],
              ),
            ),
          );
        } else {
          return Text('No data');
        }
      },
    );
  }

  Widget getAbilities(BuildContext context, List<dynamic> abilitiesList) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Abilities", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(var ability in abilitiesList)
              SizedBox(
                height: 25,
                child: ElevatedButton(
                  onPressed: () => _navigateToAbilityInfo(context, ability['ability']),
                  child: Text(ability['ability']['name'].toString().toUpperCase()),
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

  Widget getTypes(BuildContext context, List<dynamic> types) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Text("Types", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(var type in types)
              SizedBox(
                height: 25,
                child: ElevatedButton(
                  onPressed: null,
                  child: Text(type['type']['name'].toString().toUpperCase()),
                ),
              )
          ],
        )
      ],
    );
  }
}