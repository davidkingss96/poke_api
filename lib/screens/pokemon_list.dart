import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poke_api/screens/pokemon_tile.dart';
import '../services/pokemon_services.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List<Map<String, dynamic>> pokemonList = [];
  String? nextPageUrl;
  final PokemonServices pokemonService = PokemonServices();
  final PokemonTile pokemonTile = PokemonTile();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
    scrollController.addListener(scrollListener);
  }

  Future<void> fetchPokemonData() async {
    try{
      final fetchedPokemonList = await pokemonService.getPokemonList(nextPageUrl ?? 'https://pokeapi.co/api/v2/pokemon/');
      setState(() {
        var dataList = List<Map<String, dynamic>>.from(fetchedPokemonList['results']);

        nextPageUrl = fetchedPokemonList['next'];
        if(pokemonList.isNotEmpty){
          pokemonList.addAll(dataList);
        }else{
          pokemonList = dataList;
        }
      });
    }catch (err){
      print(err);
    }
  }

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      fetchPokemonData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        controller: scrollController,
        itemCount: pokemonList.length + 1,
        itemBuilder: (context, index) {
          if (index < pokemonList.length) {
            final pokemon = pokemonList[index];
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pokemonTile.extendsPokemonInfo(pokemon)),
                );
              },
              subtitle: pokemonTile.buildPokemonTile(pokemon),
            );
          } else if (nextPageUrl != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SizedBox();
          }
        }
      )
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
