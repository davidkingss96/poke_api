import 'package:localstorage/localstorage.dart';

class PokemonLocalStorage{
  final LocalStorage _storage = LocalStorage('my_app');

  Future<void> _ensureInitialized() async {
    await _storage.ready;
  }

  Future<List<Map<String, dynamic>>> getListPokemon() async {
    await _ensureInitialized();

    final storedRecords = _storage.getItem('pokemon');
    if (storedRecords == null) {
      return [];
    }
    List<Map<String, dynamic>> records =
    (storedRecords as List).cast<Map<String, dynamic>>();

    return records;
  }

  Future<void> addNewPokemonLocal(newPokemon) async {
    List<Map<String, dynamic>> records = await getListPokemon();
    var newPokObj = {
      "name": newPokemon["name"],
      "url": "https://pokeapi.co/api/v2/pokemon/${newPokemon["name"]}"
    };
    if(records.indexWhere((record) => record['name'] == newPokemon['name']) == -1){
      records.add(newPokObj);
      _storage.setItem('pokemon', records);
    }
    print(records.length);
  }
}