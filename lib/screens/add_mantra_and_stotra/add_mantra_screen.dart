import 'package:flutter/material.dart';
import 'package:jaap_app/helpers/database_helper.dart';
import 'package:jaap_app/models/mantra_model.dart';

class AddMantraScreen extends StatefulWidget {
  final Mantra? mantraToEdit;
  const AddMantraScreen({super.key, this.mantraToEdit});


  @override
  State<StatefulWidget> createState() => _AddMantraScreenState();
}

class _AddMantraScreenState extends State<AddMantraScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  static const String createNewOption = '+  Create New';

  String? _selectedType;
  String? _selectedFolder;
  List<String> _types = ['Mantra', 'Stotra', 'Other'];
  List<String> _folders = ['Default', 'Favorites'];

  @override
  void initState() {
    super.initState();

    if(widget.mantraToEdit != null){
      final mantra = widget.mantraToEdit!;
      _titleController.text = mantra.title;
      _contentController.text = mantra.content;
      _selectedType = mantra.type;
      _selectedFolder = mantra.folder;
    }
    _loadInitialData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    // _folderController.dispose();
    super.dispose();
  }

  void _loadInitialData() async {
    final dbTypes = await DatabaseHelper.instance.getAllUniqueTypes();
    final dbFolders = await DatabaseHelper.instance.getUniqueFolders();

    setState(() {
      _types = {..._types, ...dbTypes}.toList()..sort();
      _folders = {..._folders, ...dbFolders}.toList()..sort();
    });
  }

  void _showCreateDialog({required bool isFolder}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New ${isFolder ? 'Folder' : 'Type'}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: isFolder ? 'e.g., Mahadev, Ram' : 'e.g., Chalisa, Aarti',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            child: const Text('Create'),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  if (isFolder && !_folders.contains(name)) {
                    _folders.add(name);
                    _folders.sort();
                    _selectedFolder = name;
                  } else if (!isFolder && !_types.contains(name)) {
                    _types.add(name);
                    _types.sort();
                    _selectedType = name;
                  }
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _saveMantra() async {
    if (_formKey.currentState!.validate()) {
      // if (_selectedFolder == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Please select a folder.'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   return;
      // }

      Mantra mantra;
      bool isEditing = widget.mantraToEdit != null;


      if (isEditing) {
        // UPDATE
        mantra = Mantra(
          id: widget.mantraToEdit!.id, // Purani ID istemal karein
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          type: _selectedType!.trim(),
          folder: _selectedFolder!.trim(),
        );
        await DatabaseHelper.instance.update(mantra);
      } else { // Insert
        mantra = Mantra(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          type: _selectedType!.trim(),
          folder: _selectedFolder!.trim(),
        );
        await DatabaseHelper.instance.insert(mantra);
      }

      // Form save hone ke baad pichli screen par wapas chale jao
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('\'${mantra.title}\' Saved Successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        if(isEditing){
          Navigator.of(context).pop();
        }else{
          _titleController.clear();
          _contentController.clear();
          setState(() {
            _selectedType = null;
            _selectedFolder = null;
          });
          FocusScope.of(context).unfocus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Keyboard overflow error ko fix karne ke liye
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text(widget.mantraToEdit == null ? 'Add New' : 'Edit Item'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Folder Dropdown ---
                DropdownButtonFormField<String>(
                  value: _selectedFolder,
                  hint: const Text('Select a Folder'),
                  decoration: const InputDecoration(
                    labelText: 'Folder',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    ..._folders.map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    )),
                    DropdownMenuItem<String>(
                      value: createNewOption,
                      child: const Text(createNewOption,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                  onChanged: (newValue) {
                    if (newValue == createNewOption) {
                      _showCreateDialog(isFolder: true);
                    } else {
                      setState(() {
                        _selectedFolder = newValue;
                      });
                    }
                  },
                  validator: (value) =>
                  value == null ? 'Please select a folder' : null,
                ),
                const SizedBox(height: 16),

                // --- Type Dropdown ---
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  hint: const Text('Select a Type'),
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  items: [
                    ..._types.map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    )),
                    DropdownMenuItem<String>(
                      value: createNewOption,
                      child: const Text(createNewOption,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                  onChanged: (newValue) {
                    if (newValue == createNewOption) {
                      _showCreateDialog(isFolder: false);
                    } else {
                      setState(() {
                        _selectedType = newValue;
                      });
                    }
                  },
                  validator: (value) =>
                  value == null ? 'Please select a type' : null,
                ),
                const SizedBox(height: 16),

                // --- Title Field ---
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- Content Field ---
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content (Copy-Past Here )',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  maxLines: 20,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            _saveMantra();
          },
          icon: const Icon(Icons.save),
          label: const Text('Save'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
