import 'package:flutter/material.dart';
import 'package:poke_api/screens/pokemon_list.dart';
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
        page = Text('Index 1');

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
                  label: Text('Pokemon List'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.catching_pokemon, color: Colors.white),
                label: Text('Pokemon List'),
              ),
            ],//https://davidkingss96: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@github.com/davidkingss96/poke_api.git
            selectedIndex: appState.selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                appState.selectedIndex = value;
              });
            },
          ) : SizedBox(),
          Expanded(child: Container(
            child: page,
          ))
        ],
      ) 
      
    );
  }
}