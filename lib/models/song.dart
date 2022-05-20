class Song {
  String title;
  String content;
  String author;
  String uploader;
  int id = 0;

  Song(
      {required this.id,
      required this.title,
      required this.content,
      required this.uploader,
      required this.author});

  @override
  String toString() {
    return 'Song{title: $title, content: $content, author: $author, uploader: $uploader, id: $id}';
  }

  Map toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'author': author,
        'uploader': uploader,
      };

  factory Song.fromJson(dynamic json) => Song(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        author: json['author'],
        uploader: json['uploader'],
      );

  static Song empty() => Song(
      author: "ismeretlen",
      title: "",
      content: "",
      id: 0,
      uploader: "Feltöltő");
}
