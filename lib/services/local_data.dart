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

  Future<void> addNewPokemonLocal(newUser) async {
    List<Map<String, dynamic>> records = await getListPokemon();

    records.add(newUser);
    _storage.setItem('records', records);
  }
}