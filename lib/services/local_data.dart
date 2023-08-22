import 'dart:convert';
import 'dart:io';

import 'package:localstorage/localstorage.dart';

class PokemonLocalStorage{
  final LocalStorage _storage = LocalStorage('favorite_pokemon');
  final File jsonFile = File('assets/local_data.json');

  Future<void> _ensureInitialized() async {
    await _storage.ready;
  }

  Future<List<Map<String, dynamic>>> getListPokemon() async {
    //await _ensureInitialized();
    List<Map<String, dynamic>> pokemons = [];

    try {
      final jsonString = await jsonFile.readAsString();
      final data = json.decode(jsonString);
      pokemons = List<Map<String, dynamic>>.from(data['pokemons']);
    } catch(err) {
      print('Error al agregar el registro: $err');
    }
    return pokemons;

    // final storedRecords = _storage.getItem('pokemon');
    // if (storedRecords == null) {
    //   return [];
    // }
    // List<Map<String, dynamic>> records =
    // (storedRecords as List).cast<Map<String, dynamic>>();
    //
    // return records;
  }

  // Future<void> addNewPokemonLocal(newPokemon, type) async {
  //   //List<Map<String, dynamic>> records = await getListPokemon();
  //   final jsonString = await jsonFile.readAsString();
  //   final data = json.decode(jsonString);
  //   List<Map<String, dynamic>> records = List<Map<String, dynamic>>.from(data['pokemons']);
  //   for(var pokemon in newPokemon){
  //     if(records.indexWhere((record) => record['name'] == pokemon['pokemon']['name']) == -1){
  //       records.add(pokemon['pokemon']);
  //     }
  //   }
  //   print(data);
  //   data['pokemons'] = records;
  //   final updatedJsonString = json.encode(data);
  //   await jsonFile.writeAsString(updatedJsonString);
  //   // var urlImage = newPokemon['sprites']['other']['dream_world']['front_default'];
  //   // if(urlImage == null){
  //   //   urlImage = newPokemon['sprites']['other']['home']['front_default'];
  //   //   urlImage ??= newPokemon['sprites']['front_default'];
  //   // }
  //   // print(types);
  //   // var newPokObj = {
  //   //   "name": newPokemon["name"],
  //   //   "url": "https://pokeapi.co/api/v2/pokemon/${newPokemon["name"]}",
  //   //   "types": types,
  //   //   "url_image": urlImage,
  //   //   "height": newPokemon["height"],
  //   //   "weight": newPokemon["weight"]
  //   // };
  //   // if(records.indexWhere((record) => record['name'] == newPokemon['name']) == -1){
  //   //   records.add(newPokObj);
  //   //   final jsonString = await jsonFile.readAsString();
  //   //   final data = json.decode(jsonString);
  //   //   data['pokemons'] = records;
  //   //   final updatedJsonString = json.encode(data);
  //   //   await jsonFile.writeAsString(updatedJsonString);
  //   // }
  //   print(records.length);
  // }

  Future<void> addNewPokemonLocal(newPokemon, type) async {
    final jsonString = await jsonFile.readAsString();
    final data = json.decode(jsonString);
    List<Map<String, dynamic>> records = List<Map<String, dynamic>>.from(data['pokemons']);

    for (var pokemon in newPokemon) {
      final existingIndex = records.indexWhere((record) => record['name'] == pokemon['pokemon']['name']);
      if (existingIndex == -1) {
        final pokemonType = pokemon['pokemon']['type'] ?? [];
        if (!pokemonType.contains(type)) {
          pokemonType.add(type);
        }
        pokemon['pokemon']['type'] = pokemonType;
        records.add(pokemon['pokemon']);
      } else {
        final pokemonType = records[existingIndex]['type'] ?? [];
        if (!pokemonType.contains(type)) {
          pokemonType.add(type);
        }
        records[existingIndex]['type'] = pokemonType;
      }
    }
    data['pokemons'] = records;
    final updatedJsonString = json.encode(data);
    await jsonFile.writeAsString(updatedJsonString);
  }

  Future<void> addPokemonFavorite(name) async {
    bool exist = await validateFavorite(name);
    if (!exist) {
      final favoriteList = _storage.getItem('favorite_pokemon') ?? [];
      favoriteList.add({'name': name});
      await _storage.setItem('favorite_pokemon', favoriteList);
    }
  }

  Future<bool> validateFavorite(name) async {
    final favoriteList = _storage.getItem('favorite_pokemon') ?? [];
    final existingIndex = favoriteList.indexWhere((pokemon) => pokemon['name'] == name);
    print(favoriteList);
    if (existingIndex == -1) {
      return false;
    }else{
      return true;
    }
  }
}