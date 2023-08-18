import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poke_api/screens/pokemon_tile.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../services/pokemon_services.dart';

class SearchPokemon extends StatefulWidget {
  @override
  State<SearchPokemon> createState() => _SearchPokemonState();
}

class _SearchPokemonState extends State<SearchPokemon> {
  String? search;
  TextEditingController editingController = TextEditingController();
  final PokemonTile pokemonTile = PokemonTile();
  List<Map<String, dynamic>> typeList = [];
  final PokemonServices pokemonService = PokemonServices();
  late List _selectedTypes = [];

  Future<List> readFileContents() async {
    try {
      List<Map<String, dynamic>> pokemons = [];
      final contents = await rootBundle.loadString('assets/local_data.json');
      final data = jsonDecode(contents);
      pokemons = List<Map<String, dynamic>>.from(data['pokemons']);
      var pokemonList = [];
      if(search != null){
        pokemonList = pokemons.where((item) => item['name'].toLowerCase().contains(search?.toLowerCase()))
            .toList();
      }else{
        pokemonList = pokemons;
      }
      if(_selectedTypes != null && _selectedTypes.isNotEmpty){
        pokemonList = pokemonList.where((item) {
          final List<String> pokemonTypes = List<String>.from(item['type']);
          return _selectedTypes.any((selectedType) => pokemonTypes.contains(selectedType['name']));
        }).toList();
      }
      return pokemonList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> fetchTypesData() async {
    try{
      final fetchedPokemonList = await pokemonService.getData('https://pokeapi.co/api/v2/type/');
      setState(() {
        var dataList = List<Map<String, dynamic>>.from(fetchedPokemonList['results']);
        typeList = dataList;
        print(typeList);
      });
    }catch (err){
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTypesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            MultiSelectDialogField(
              items: typeList.map((type) => MultiSelectItem(type, type['name'])).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                setState(() {
                  _selectedTypes = values;
                  print(_selectedTypes);
                });
              },
            ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => pokemonTile.buildPokemonTile(data![index], extended: true)),
                              );
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
        )
      ),
    );
  }
}
