import 'package:flutter/material.dart';
import '../../helpers/database_helper.dart';
import '../../models/mantra_model.dart';
import '../../widgets/edit_delete_menu.dart';
import '../add_mantra_and_stotra/add_mantra_screen.dart';
import 'detail_screen.dart';

class TitleListScreen extends StatefulWidget {
  final String folderName;
  final String typeName;

  const TitleListScreen({super.key, required this.folderName, required this.typeName});

  @override
  State<TitleListScreen> createState() => _TitleListScreenState();
}

class _TitleListScreenState extends State<TitleListScreen> {
  Future<List<Mantra>>? _mantraListFuture;

  @override
  void initState() {
    super.initState();
    _mantraListFuture = DatabaseHelper.instance.getMantrasByFolderAndType(
      widget.folderName,
      widget.typeName,
    );
  }

  void _loadMantras() {
    setState(() {
      _mantraListFuture = DatabaseHelper.instance.getMantrasByFolderAndType(
        widget.folderName,
        widget.typeName,
      );
    });
  }

  void _confirmAndDelete(Mantra mantra) async {
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '${mantra.title}'?"),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("CANCEL")),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("DELETE"),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await DatabaseHelper.instance.delete(mantra.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("'${mantra.title}' deleted")),
      );
      _loadMantras();
    }
  }

  void _navigateToEditScreen(Mantra mantra) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMantraScreen(mantraToEdit: mantra),
      ),
    );
    _loadMantras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text(widget.typeName),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Mantra>>(
        future: _mantraListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No items found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final mantraList = snapshot.data!;
          mantraList.sort((a, b) => a.title.compareTo(b.title));

          return ListView.builder(
            itemCount: mantraList.length,
            itemBuilder: (context, index) {
              final mantra = mantraList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 16.0, right: 0.0),
                  leading: const Icon(Icons.article_outlined , color: Colors.orange,),
                  title: Text(
                    mantra.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  //trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentDetailScreen(
                          mantra: mantra,
                        ),
                      ),
                    );
                    _loadMantras();
                  },
                  trailing: EditDeleteMenu(
                    onEdit: () {
                      _navigateToEditScreen(mantra);
                    },
                    onDelete: () {
                      _confirmAndDelete(mantra);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}