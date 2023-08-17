import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_api/screens/pokemon_tile.dart';

import '../services/pokemon_services.dart';

class TypeList extends StatefulWidget {
  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  List<Map<String, dynamic>> typeList = [];
  final PokemonServices pokemonService = PokemonServices();
  final PokemonTile pokemonTile = PokemonTile();

  @override
  void initState() {
    super.initState();
    fetchTypesData();
  }

  Future<void> fetchTypesData() async {
    try{
      final fetchedPokemonList = await pokemonService.getData('https://pokeapi.co/api/v2/type/');
      setState(() {
        var dataList = List<Map<String, dynamic>>.from(fetchedPokemonList['results']);
        typeList = dataList;
      });
    }catch (err){
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          for(var type in typeList)
            ExpansionTile(
              title: Text(type['name']),
              children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: pokemonService.getData(type['url']),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    } else if (snapshot.hasError) {
                      return Text('Error');
                    } else if (snapshot.hasData) {
                      final pokemonOfType = snapshot.data!["pokemon"];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              for(var pokemon in pokemonOfType)
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => pokemonTile.buildPokemonTile(pokemon["pokemon"], extended: true)),
                                      );
                                    },
                                    child: Text(pokemon["pokemon"]["name"]),
                                ),
                                // pokemonTile.buildPokemonTile(pokemon["pokemon"]),
                            ],
                          )
                        ],
                      );
                    } else {
                      return Text('No data');
                    }
                  },
                )
              ],
            ),
        ],
      ),
    );
  }
}