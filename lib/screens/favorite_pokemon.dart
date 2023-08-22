import 'package:flutter/cupertino.dart';

class FavoritePokemon extends StatefulWidget{
  @override
  State<FavoritePokemon> createState() => _FavoritePokemonState();
}

class _FavoritePokemonState extends State<FavoritePokemon> {
  @override
  Widget build(BuildContext context) {
    return Text('Likes');
  }
}