import 'package:flutter/material.dart';

import '../services/pokemon_services.dart';

class Evolutions extends StatefulWidget {
  final pokemonData;

  const Evolutions(this.pokemonData);

  @override
  State<Evolutions> createState() => _EvolutionsState();
}

class _EvolutionsState extends State<Evolutions> {
  final PokemonServices pokemonService = PokemonServices();
  var pokemonSpecies;

  @override
  void initState() {
    super.initState();
    fetchSpecies();
    print(pokemonSpecies);
  }

  Future<void> fetchSpecies() async {
    try{
      final fetchedPokemonList = await pokemonService.getData(widget.pokemonData['species']['url']);
      pokemonSpecies = fetchedPokemonList['evolution_chain'];
    }catch (err){
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.pokemonData);

    return Scaffold(

      //appBar: AppBar(title: Text("Testing")),
      body: Text("Prueba"),
    );
  }
}