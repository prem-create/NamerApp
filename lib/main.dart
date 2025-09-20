import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: Consumer<MyAppState>( // 👈 listen to theme changes
        builder: (context, appState, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Namer App',
            themeMode: appState.themeMode, // 👈 dynamic theme mode
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.dark),
            ),
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // -------------------
  // THEME HANDLING
  // -------------------
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void getNext(){    
    //function that get triggered when next button is pressed
    current= WordPair.random();
    notifyListeners(); 
  }

  var favorites = <WordPair>[];

  void toggleFavorite(){
    if(favorites.contains(current)){
      favorites.remove(current);
    }
    else
    {
      favorites.add(current);
    }
    notifyListeners();
  }

WordPair? lastDeletedFavorites ;
int? lastDeletedIndex ;
List<WordPair> lastDeletedMultipleFavorites=[];
List<int> lastDeletedMultipleIndexes=[];

void deleteFavorite(index){
lastDeletedFavorites = favorites[index];
lastDeletedIndex= index;
favorites.removeAt(index);
notifyListeners();
}

void deleteMultipleFavorite(indexes , selectedWordPairs){
  lastDeletedMultipleFavorites= selectedWordPairs;
  lastDeletedMultipleIndexes = indexes;
  for(int i= lastDeletedMultipleIndexes.length-1;i>=0;i--){
  favorites.removeAt(indexes[i]);
  }
  notifyListeners();
  }

void unDoDelete(){
  if(lastDeletedFavorites != null && lastDeletedIndex != null){
    favorites.insert(lastDeletedIndex! , lastDeletedFavorites! );
    notifyListeners();
    }
  }  

void undoMultipleDelete() {
  for (int i = lastDeletedMultipleIndexes.length - 1; i >= 0; i--) {
    int insertIndex = lastDeletedMultipleIndexes[i];
    if (insertIndex > favorites.length) {
      insertIndex = favorites.length;
    }
    favorites.insert(insertIndex, lastDeletedMultipleFavorites[i]);
  }
  notifyListeners();
  }
}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

Widget page;
switch (selectedIndex) {
  case 0:
    page = GeneratorPage(); 
  case 1:
    page = FavoritesPage();
  default:
    throw UnimplementedError('no widget for $selectedIndex');
}

    return LayoutBuilder(
      builder: (context, contraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Namer App'),
            actions: [
                IconButton( // 👈 theme toggle button
                icon: Icon(Icons.brightness_6),
                onPressed: () {
                  context.read<MyAppState>().toggleTheme();
                },
                          ),
      ]
          ),
  body: Row(
    children: [
      
      SafeArea(
        child: NavigationRail(
          extended: contraints.maxWidth >= 600,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.favorite),
              label: Text('Favorites'),
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ),
      ),
      Expanded(
        child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: page,
        ),
      ),
    ],
  ),
);

      }
    );
  }
}

//Genetator page
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('An  AMAZING Word Pair idea!!! ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
          ),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//favoritesPage

class FavoritesPage extends StatefulWidget{

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
    bool isSelectioinModeOn= false;
    Set<int> selectedIndexes = {};
    List<WordPair> selectedWordPair =[];

    void toggleSelection(int index){
      
      setState((){
        if(selectedIndexes.contains(index)){
          selectedIndexes.remove(index);
          if(selectedIndexes.isEmpty){
            isSelectioinModeOn =false;
          }
        }
        else{
          selectedIndexes.add(index);
        }
        print (selectedIndexes);
      }
      );
    }

@override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List allFavorites = appState.favorites;
    int noOfElementsInFavorites= allFavorites.length;
    if(allFavorites.isEmpty){
      return Center(
        child: const Text('No favorite wordpair yet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:25,
            ),
          )
        );
    }
    return Scaffold(
      appBar: AppBar(
        title:  isSelectioinModeOn?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed:(){
                selectedWordPair.clear();
                for(int i=selectedIndexes.length-1;i>=0;i--){
                  selectedWordPair.add(appState.favorites[selectedIndexes.elementAt(i)]);
                }
                appState.deleteMultipleFavorite(selectedIndexes.toList(), selectedWordPair);
                selectedIndexes.clear();
                isSelectioinModeOn= false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted all selected items'),
                    action: SnackBarAction(
                      label: 'UnDo', 
                      onPressed: (){
                        appState.undoMultipleDelete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('restored')
                          )
                        );
                      }
                    ),
                  )
                );
              } , 
              child:Text('Delete selected')
              ),
          ],
        )
        :
        Text(
          'All your $noOfElementsInFavorites FAVORITE wordpairs at one place 👇 ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:25,
          ),
        ),
      ),
        body: ListView.builder(
          itemCount: noOfElementsInFavorites,
          itemBuilder: (context,index){
            return ListTile(
              onLongPress: (){
                isSelectioinModeOn= true;
                toggleSelection(index);
              },
              onTap: (){
                if(isSelectioinModeOn== true){
                  toggleSelection(index);
                }
              },
              
              leading: isSelectioinModeOn? 
              (
                selectedIndexes.contains(index)?
              Icon(Icons.circle_rounded):
              Icon(Icons.circle_outlined)
              )
              :
              Text('${index+1}.',
                style: TextStyle( 
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              
              title: Text(allFavorites[index].asLowerCase,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                ) ,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSelectioinModeOn? SizedBox.shrink(): CopyToClipBoard(text:"${allFavorites[index].asLowerCase}"),
                  SizedBox(width:5),
                  isSelectioinModeOn? SizedBox.shrink():ElevatedButton(
                    onPressed: (){
                      appState.deleteFavorite(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleted'),
                          duration: Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'UnDo',
                            onPressed: (){
                              appState.unDoDelete();
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content:Text('recovered'),
                              )
                              );
                            }
                          ),
                        )
                      );
                    }, 
                    child: Text('Delete')
                  ),
                  isSelectioinModeOn? SizedBox.shrink():ElevatedButton(
                    onPressed: (){
                    SharePlus.instance.share(
                    ShareParams(
                        text: "Hey! have a look I found an interesting word pair in Namer app: ${allFavorites[index].asLowerCase}",
                        subject: "Namer App favorites",
                        ),
                    );  
                    },
                    child: Text('Share'),
                  ),
                ],
              ) ,
          );
        }
      )
    );
  }
}

/*  ulternative code for the same FavoritesPage but the one i created has a bit more features

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}*/



class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Card(
        color: theme.colorScheme.primary,
      
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(pair.asLowerCase,
          style:style,
          semanticsLabel: "${pair.first} ${pair.second}",    
          /*i found out syntax is okay and it might work
          but it is not working in my default narrator , this portion in
          perticular needs thorough checking  */
        ),
      ),
    );
  }
}

class CopyToClipBoard extends StatelessWidget {

final String text;

CopyToClipBoard({super.key ,required this.text});
@override
Widget build(BuildContext context){
  return IconButton(
    onPressed: (){
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('copied to clipboard')
          )
      );
    }
  , icon: const Icon(Icons.copy)) ;
}
}