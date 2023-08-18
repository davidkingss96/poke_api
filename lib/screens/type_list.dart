import 'package:flutter/material.dart';
import 'package:poke_api/screens/pokemon_tile.dart';

import '../services/local_data.dart';
import '../services/pokemon_services.dart';

class TypeList extends StatefulWidget {
  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  List<Map<String, dynamic>> typeList = [];
  final PokemonServices pokemonService = PokemonServices();
  final PokemonTile pokemonTile = PokemonTile();
  final PokemonLocalStorage pokemonLocalStorage = PokemonLocalStorage();

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

  Future<void> fetchPokemonDataAndBuildTile(List<dynamic> pokemon, type) async {
    //final pokemonData = await pokemonService.getData(pokemon['url']);
    pokemonLocalStorage.addNewPokemonLocal(pokemon, type);
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
                      fetchPokemonDataAndBuildTile(pokemonOfType, type['name']);
                      List<Widget> buttonRows = [];
                      for (var i = 0; i < pokemonOfType.length; i += 3) {
                        List<Widget> buttons = [];
                        for (var j = i; j < i + 3 && j < pokemonOfType.length; j++) {
                          var urlExplode = pokemonOfType[j]["pokemon"]["url"].toString().split('/');
                          var urlImageConcat = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${urlExplode[urlExplode.length - 2]}.png';
                          buttons.add(
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => pokemonTile.buildPokemonTile(pokemonOfType[j]["pokemon"], extended: true)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                backgroundColor: Colors.blue,
                              ),
                              child: Image.network(
                                urlImageConcat,
                                width: 90,
                                height: 90,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Text('Image not found');
                                },
                              ),
                            ),
                          );
                        }
                        buttonRows.add(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: buttons,
                        ));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: buttonRows,
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