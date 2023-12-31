import 'package:flutter/material.dart';
import 'package:poke_api/screens/favorite_pokemon.dart';
import 'package:poke_api/screens/pokemon_list.dart';
import 'package:poke_api/screens/search_pokemon.dart';
import 'package:poke_api/screens/type_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class AppState extends ChangeNotifier {
  bool _showRail = true;

  bool get showRail => _showRail;

  set showRail(bool show){
    _showRail = show;
    notifyListeners();
  }
  
  int _selectedIndex = 0;
  
  int get selectedIndex => _selectedIndex;
  
  set selectedIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }

  bool _extendedNavigationRail = false;

  bool get extendedNavigationRail => _extendedNavigationRail;

  set extendedNavigationRail(bool show){
    _extendedNavigationRail = show;
    notifyListeners();
  }

  int _columnsPokemonList = 2;

  int get columnsPokemonList => _columnsPokemonList;

  set columnsPokemonList(int index){
    _columnsPokemonList = index;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    Widget page;

    switch(appState.selectedIndex){
      case 0:
        page = PokemonList();
      case 1:
        page = TypeList();
      case 2:
        page = SearchPokemon();
      case 3:
        page = FavoritePokemon();

      default:
        throw UnimplementedError('no widget for $appState.selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pokemon API', style: TextStyle(color: Colors.white)),
        leadingWidth: 80,
        leading: IconButton(
          icon: const Icon(Icons.reorder, color: Colors.white),
          onPressed: () {
            setState(() {
              appState.showRail = !appState.showRail;
            });
          },
        ),
      ),
      body: Row(
        children: [
          appState.showRail ? NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.catching_pokemon, color: Colors.white),
                  label: Text('Pokemon List', style: TextStyle(color: Colors.white))
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_tree_rounded, color: Colors.white),
                label: Text('Pokemon Types', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search, color: Colors.white),
                label: Text('Pokemon Search', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite, color: Colors.white),
                label: Text('Pokemon like', style: TextStyle(color: Colors.white)),
              ),
            ],
            selectedIndex: appState.selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                appState.selectedIndex = value;
              });
            },
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  onPressed: () async {
                    setState(() {
                      appState.extendedNavigationRail = !appState.extendedNavigationRail;
                    });
                    if(appState.extendedNavigationRail){
                      appState.columnsPokemonList = 1;
                    }else{
                      await Future.delayed(const Duration(milliseconds: 300));
                      appState.columnsPokemonList = 2;
                    }
                  },
                  icon: appState.extendedNavigationRail ?
                  Icon(Icons.keyboard_arrow_left, color: Colors.white) :
                  Icon(Icons.keyboard_arrow_right, color: Colors.white),
                ),
              ),
            ),
            extended: appState.extendedNavigationRail,
          ) : SizedBox(),
          Expanded(child: Container(
            child: page,
          ))
        ],
      ) 
      
    );
  }
}
