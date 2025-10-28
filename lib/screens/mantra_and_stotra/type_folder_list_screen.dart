// lib/screens/type_folder_list_screen.dart

import 'package:flutter/material.dart';
import 'package:jaap_app/screens/mantra_and_stotra/title_folder_list_screen.dart';

import '../../helpers/database_helper.dart';

class ContentTypeScreen extends StatefulWidget {
  final String folderName;

  // Constructor: Is screen ko call karte waqt folder ka naam dena zaroori hai.
  const ContentTypeScreen({super.key, required this.folderName});

  @override
  State<ContentTypeScreen> createState() => _ContentTypeScreenState();
}

class _ContentTypeScreenState extends State<ContentTypeScreen> {
  Future<List<String>>? _typesFuture;

  @override
  void initState() {
    super.initState();
    _typesFuture = DatabaseHelper.instance.getUniqueTypesForFolder(widget.folderName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.folderName),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: _typesFuture,
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Error State
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No items found in this folder.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Data successfully loaded
          final types = snapshot.data!;
          types.sort();

          return ListView.builder(
            itemCount: types.length,
            itemBuilder: (context, index) {
              final typeName = types[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  //leading: const Icon(Icons.subdirectory_arrow_right, color: Colors.orange,),
                  title: Text(
                    typeName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    print('--- Navigating from ContentTypeScreen ---');
                    print('Folder Name Sent: "${widget.folderName}"');
                    print('Type Name Sent: "$typeName"');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TitleListScreen(
                          folderName: widget.folderName,
                          typeName: typeName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}