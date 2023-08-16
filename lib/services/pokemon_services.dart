import 'dart:convert';

import 'package:http/http.dart' as http;

class PokemonServices {

  Future<http.Response> getApiData(String url) async {
    final response = await http.get(Uri.parse(url));
    return response;
  }

  Future<Map<String, dynamic>> getPokemonList(String url) async {
    final response = await getApiData(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to list pokemon.');
    }
    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getData(String pokemonUrl) async {
    final response = await getApiData(pokemonUrl);
    if (response.statusCode != 200) {
      throw Exception('Failed to get pokemon.');
    }
    final data = jsonDecode(response.body);
    return data;
  }

}