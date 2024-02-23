import 'dart:convert';

class ContentList {
  // int id;
  String content;
  bool checked;

  ContentList({
    // required this.id,
    required this.content,
    this.checked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'content': content,
      'checked': checked ? 1 : 0,
    };
  }

  factory ContentList.fromMap(Map<String, dynamic> map) {
    return ContentList(
      // id: map['id'],
      content: map['content'],
      checked: map['checked'] == 1 ? true : false,
    );
  }
}

class CardType {
  int id; // id现在是可空类型，因为它将自动由数据库生成
  String title;
  List<ContentList> contentList;
  int created_at; // TODO: createdAt
  int updated_at;

  CardType({
    required this.id,
    required this.title,
    this.contentList = const [],
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id, // 不需要添加'id': id，因为SQLite将自动生成它 // toMap的时候不要
      'title': title,
      'contentList': jsonEncode(contentList.map((x) => x.toMap()).toList()),
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory CardType.fromMap(Map<dynamic, dynamic> map) {
    return CardType(
      id: map['id'] ?? 0, // ?没创建id？不对吧
      title: map['title'],
      contentList: map['contentList'] != null
        ? List<ContentList>.from(
            jsonDecode(
              map['contentList']).map((x) => ContentList.fromMap(x)
            )
          )
        : [],
      created_at: map['created_at'] ?? 0,
      updated_at: map['updated_at'] ?? 0,
    );
  }
}
