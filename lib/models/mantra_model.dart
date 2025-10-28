class Mantra{
  final int? id;
  final String title;
  final String content;
  final String type;
  final String folder;

  Mantra({
    this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.folder
  });

  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'folder': folder,
    };
  }

  factory Mantra.fromMap(Map<String, dynamic> map){
    return Mantra(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      type: map['type'],
      folder: map['folder']
    );
  }
}