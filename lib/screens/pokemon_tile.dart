import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poke_api/screens/stats.dart';
import 'package:poke_api/screens/types.dart';

import '../services/local_data.dart';
import '../services/pokemon_services.dart';
import 'abilities.dart';

class PokemonTile extends StatefulWidget{
  final Map<String, dynamic> pokemon;
  final bool extended;
  const PokemonTile({this.extended = false, required this.pokemon});

  @override
  State<PokemonTile> createState() => _PokemonTileState();
}

class _PokemonTileState extends State<PokemonTile> {
  final PokemonServices pokemonService = PokemonServices();
  final PokemonLocalStorage pokemonLocalStorage = PokemonLocalStorage();

  @override
  Widget build(BuildContext context) {
    print(widget.extended);
    if(!widget.extended){
      var urlExplode = widget.pokemon['url'].toString().split('/');
      var urlImageConcat = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/${urlExplode[urlExplode.length - 2]}.svg';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.network(urlImageConcat, width: 90, height: 90,),
          Text(widget.pokemon['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      );
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: pokemonService.getData(widget.pokemon['url']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator()
            ],
          );
        } else if (snapshot.hasError) {
          print(widget.pokemon['url']);
          return Text('Error${snapshot.error}');
        } else if (snapshot.hasData) {
          final pokemonData = snapshot.data!;
          if(widget.extended){
            return extendsPokemonInfo(pokemonData, context);
          }else{
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
          }
        } else {
          return Text('No data');
        }
      },
    );
  }

  Widget extendsPokemonInfo(Map<String, dynamic> pokemonData, context) {
    final pokemonName = pokemonData['name'].toString().toUpperCase();
    final pokemonHeight = pokemonData['height'];
    final pokemonWeight = pokemonData['weight'];
    var urlImage = pokemonData['sprites']['other']['dream_world']['front_default'];
    Widget image;
    if(urlImage != null){
      image = SvgPicture.network(urlImage, width: 90, height: 90);
    }else{
      urlImage = pokemonData['sprites']['other']['home']['front_default'];
      urlImage ??= pokemonData['sprites']['front_default'];
      if(urlImage != null){
        image = Image.network(urlImage, width: 90, height: 90);
      }else{
        image = Text('File not found');
      }
    }
    final List abilities = pokemonData['abilities'];
    final List stats = pokemonData['stats'];
    final List types = pokemonData['types'];

    return FutureBuilder(
      future: pokemonLocalStorage.validateFavorite(pokemonName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var isPokemonFavorite = snapshot.data ?? false;
          return Scaffold(
            appBar: AppBar(title: Text("POKEMON $pokemonName")),
            body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      borderOnForeground: true,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      child:  SizedBox(
                        width: 400,
                        height: 500,
                        child: Column(
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
                              height: 30.0,
                              child: Text(pokemonName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                            ),
                            Container(
                              color: Colors.white,
                              width: 350.0,
                              height: 120.0,
                              child: image,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              width: 350.0,
                              height: 30.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Height: $pokemonHeight', style: TextStyle(color: Colors.white),),
                                  SizedBox(width: 30),
                                  Text('Weight: $pokemonWeight', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 350.0,
                              child: Column(
                                children: [
                                  getAbilities(context, abilities),
                                  getTypes(context, types),
                                  getStats(stats),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          elevation: 3,
                          onPressed: () {
                            setState(() {
                              pokemonLocalStorage.addPokemonFavorite(pokemonName);
                              isPokemonFavorite = true;
                            });
                          },
                          backgroundColor: Colors.red,
                          child: isPokemonFavorite ?
                          Icon(Icons.favorite, color: Colors.white,) : Icon(Icons.favorite_border, color: Colors.white,),
                        ),
                        SizedBox(width: 20)
                      ],
                    )
                  ],
                )
            ),
          );
        }
      },
    );
  }
}
