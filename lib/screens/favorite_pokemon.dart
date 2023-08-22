import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:poke_api/screens/pokemon_tile.dart';

class FavoritePokemon extends StatefulWidget{
  @override
  State<FavoritePokemon> createState() => _FavoritePokemonState();
}

class _FavoritePokemonState extends State<FavoritePokemon> {

  Future<List> readFileContents() async {
    try {
      final LocalStorage storage = LocalStorage('favorite_pokemon');
      final storedRecords = storage.getItem('favorite_pokemon');
      if (storedRecords == null) {
        return [];
      }else{
        return storedRecords;
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                  future: readFileContents(),
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
                              title: Text('${data?[index]['name']}'),
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
                },
              )
            )
          ],
        ),
      ),
    );
  }
}