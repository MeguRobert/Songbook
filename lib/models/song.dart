import 'package:hello_word/constants.dart';

import '../globals.dart';

class Song {
  String title;
  String content;
  String author;
  String uploader;
  String uploaderEmail;
  String lastEditedByEmail;
  String approvedBy;
  bool approved;
  int id = 0;

  Song({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.uploader,
    required this.uploaderEmail,
    required this.lastEditedByEmail,
    required this.approved,
    required this.approvedBy,
  });

  factory Song.fromJson(dynamic json) => Song(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        author: json['author'],
        uploader: json['uploader'],
        approved: json["approved"] ?? false,
        approvedBy: json["approvedBy"] ?? "",
        uploaderEmail: json["uploaderEmail"] ?? "",
        lastEditedByEmail: json["lastEditedByEmail"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'content': content,
        'approved': approved,
        'approvedBy': approvedBy,
        'uploader': uploader,
        'uploaderEmail': uploaderEmail,
        'lastEditedByEmail': lastEditedByEmail,
      };

  @override
  String toString() {
    return 'Song{title: $title, content: $content, author: $author, uploader: $uploaderEmail, id: $id, approvedBy: $approvedBy}';
  }

  static Song empty() => Song(
        id: 0,
        title: "",
        author: defaultAuthor[language],
        content: "",
        approved: false,
        approvedBy: "",
        uploader: defaultUploader[language],
        uploaderEmail: defaultUploader[language],
        lastEditedByEmail: defaultUploader[language],
      );
}
