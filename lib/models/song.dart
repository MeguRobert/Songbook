import 'package:hello_word/constants.dart';
import 'package:provider/provider.dart';

import '../globals.dart';

class Song {
  String title;
  String content;
  String author;
  String uploader;
  String lastEditedByEmail;
  String uploaderEmail;
  String approvedBy;
  bool approved;
  int id = 0;

  Song(
      {required this.id,
      required this.title,
      required this.content,
      required this.uploader,
      required this.uploaderEmail,
      required this.lastEditedByEmail,
      required this.approvedBy,
      required this.approved,
      required this.author});

  @override
  String toString() {
    return 'Song{title: $title, content: $content, author: $author, uploader: $uploaderEmail, id: $id, approvedBy: $approvedBy}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'author': author,
        'uploader': uploader,
        'uploaderEmail': uploaderEmail,
        'lastEditedByEmail': lastEditedByEmail,
        'approvedBy': approvedBy,
        'approved': approved,
      };

  factory Song.fromJson(dynamic json) => Song(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        author: json['author'],
        uploader: json['uploader'],
        approved: json["approved"] ?? false,
        approvedBy: json["approvedBy"] ?? "",
        lastEditedByEmail: json["lastEditedByEmail"] ?? "",
        uploaderEmail: json["uploaderEmail"] ?? "",
      );

  static Song empty() => Song(
        author: defaultAuthor[language],
        title: "",
        content: "",
        id: 0,
        uploader: defaultUploader[language],
        approved: false,
        approvedBy: "",
        lastEditedByEmail: defaultUploader[language],
        uploaderEmail: defaultUploader[language],
      );
}
