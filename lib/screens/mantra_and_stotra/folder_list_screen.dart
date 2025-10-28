import 'package:flutter/material.dart';
import 'package:jaap_app/helpers/database_helper.dart';
import 'type_folder_list_screen.dart';

class FolderListScreen extends StatefulWidget {
  const FolderListScreen({super.key});

  @override
  State<StatefulWidget> createState() => FolderListScreenState();
}

class FolderListScreenState extends State<FolderListScreen> {
  Future<List<String>>? _folderListFuture;

  @override
  void initState() {
    super.initState();
    _folderListFuture = DatabaseHelper.instance.getUniqueFolders();
  }

  void refreshFolders() {
    setState(() {
      _folderListFuture = DatabaseHelper.instance.getUniqueFolders();
    });
  }

  //Design part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text('List of God(Bhagavan)'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _folderListFuture,
          builder: (context, snapshot){
            // Case 1: Jab data abhi tak nahi aaya hai (loading ho raha hai)
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }

            // Case 2: Agar data laate waqt koi error aa gaya
            if(snapshot.hasError){
              return Center(child: Text('Error : ${snapshot.error}'),);
            }

            // Case 3: Agar data aa gaya lekin list khaali hai (koi folder nahi hai)
            if(!snapshot.hasData || snapshot.data!.isEmpty){
              return const Center(
                child: Text(
                  'No mantra and sotra found. \n Add a mantra and sotra from the "Add Mantra" Section',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            // Case 4: Jab data successfully aa gaya hai
            final folders = snapshot.data!;
            folders.sort();  // Folders ko alphabetically sort karega.

            return ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index){
                final folderName = folders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.folder, color: Colors.orange,),
                    title: Text(
                      folderName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),

                    //folder ke andar jane ke liye
                    trailing: const Icon(Icons.chevron_right),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContentTypeScreen(folderName: folderName)
                        )
                      );
                    },
                  ),
                );
              },
            );
          }
      ),
    );
  }
}


























