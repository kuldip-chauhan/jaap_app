import 'package:flutter/material.dart';
import '../../models/mantra_model.dart';

class ContentDetailScreen extends StatelessWidget {
  final Mantra mantra;
  const ContentDetailScreen({super.key, required this.mantra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text(mantra.title),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          mantra.content,
          style: const TextStyle(
            fontSize: 20,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}