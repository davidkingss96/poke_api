import 'package:flutter/material.dart';
import 'package:poke_api/screens/pokemon_tile.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/pokemon_services.dart';

class Evolutions extends StatefulWidget {
  final pokemonData;

  const Evolutions(this.pokemonData);

  @override
  State<Evolutions> createState() => _EvolutionsState();
}

class _EvolutionsState extends State<Evolutions> {
  final PokemonServices pokemonService = PokemonServices();
  var pokemonSpecies = {};
  var pokemonEvolutions = [];

  void extractEvolutions(List<dynamic> evolvesTo) {
    for (var evolution in evolvesTo) {
      String speciesName = evolution["species"]["name"];
      String speciesUrl = evolution["species"]["url"];
      //
      // print("Species Name: $speciesName");
      // print("Species URL: $speciesUrl");

      final pokemonEvolution = {
        'name': speciesName,
        'url': speciesUrl.replaceAll('pokemon-species', 'pokemon'),
      };

      pokemonEvolutions.add(pokemonEvolution);

      List<dynamic> nextEvolutions = evolution["evolves_to"];
      if (nextEvolutions.isNotEmpty) {
        extractEvolutions(nextEvolutions);
      }
    }
  }

  Future<List> fetchSpecies() async {
    try {
      pokemonEvolutions = [];
      final fetchedPokemonList = await pokemonService.getData(widget.pokemonData['species']['url']);
      pokemonSpecies = fetchedPokemonList['evolution_chain'];
      final fetchedEvolution = await pokemonService.getData(pokemonSpecies['url']);

      final pokemonSpecie = {
        'name': fetchedEvolution["chain"]["species"]["name"],
        'url': fetchedEvolution["chain"]["species"]["url"].replaceAll('pokemon-species', 'pokemon'),
      };

      pokemonEvolutions.add(pokemonSpecie);

      List<dynamic> evolvesTo = fetchedEvolution["chain"]["evolves_to"];
      extractEvolutions(evolvesTo);

      return pokemonEvolutions;
    } catch (err) {
      print(err);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Evolutions")),
      body: FutureBuilder(
        future: fetchSpecies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                var urlExplode =  data![index]["url"].toString().split('/');
                var urlImageConcat = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${urlExplode[urlExplode.length - 2]}.png';
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      urlImageConcat,
                      width: 90,
                      height: 90,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Text('Image not found');
                      },
                    ),
                    title: appState.extendedNavigationRail ? SizedBox() : Text('${data?[index]['name']}'),
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PokemonTile(pokemon: data![index], extended: true)),
                        ).then((value) {
                          setState(() {

                          });
                        });
                      });
                    },
                  ),
                );
              },
            );
          }
        }
      )
    );
  }
}