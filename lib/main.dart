import 'package:flutter/material.dart';
import 'package:jaap_app/screens/add_mantra_and_stotra/add_mantra_screen.dart';
import 'package:jaap_app/screens/mala_counter/mala_counter_screen.dart';
import 'package:jaap_app/screens/mantra_and_stotra/folder_list_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japa App',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          //primaryColor: Colors.amber
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;
  final GlobalKey<FolderListScreenState> _folderListKey = GlobalKey<FolderListScreenState>();

  late final List<Widget> _widgetOptions;

  static const List<String> _appBarTitles = <String>[
    'Mala Counter',
    'Mantra & Stotra',
    'Add Mantra & Stotra'
  ];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const MalaCounterScreen(),
      FolderListScreen(key: _folderListKey),
      const AddMantraScreen(),
    ];
  }


  void _onItemTapped(int index) {
    if (index == 1) {
      _folderListKey.currentState?.refreshFolders();
    }
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'Mala Counter'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Mantra & Stotra'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Mantra & Stotra'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orangeAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
    
    
    
    
    
    
    
    
    
    
    
    
    