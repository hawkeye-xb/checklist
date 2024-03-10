import 'dart:convert';

class CheckListItemType {
  // int id;
  String content;
  bool checked;

  CheckListItemType({
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

  factory CheckListItemType.fromMap(Map<String, dynamic> map) {
    return CheckListItemType(
      // id: map['id'],
      content: map['content'],
      checked: map['checked'] == 1 ? true : false,
    );
  }

  CheckListItemType copyWith({
    // int? id,
    String? content,
    bool? checked,
  }) {
    return CheckListItemType(
      // id: id ?? this.id,
      content: content ?? this.content,
      checked: checked ?? this.checked,
    );
  }
}

class CardType {
  int id; // id现在是可空类型，因为它将自动由数据库生成
  String title;
  List<CheckListItemType> contentList;
  int created_at; // TODO: createdAt
  int updated_at;
  bool favorite;

  CardType({
    required this.id,
    required this.title,
    this.contentList = const [],
    required this.created_at,
    required this.updated_at,
    this.favorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id, // 不需要添加'id': id，因为SQLite将自动生成它 // toMap的时候不要
      'title': title,
      'contentList': jsonEncode(contentList.map((x) => x.toMap()).toList()),
      'created_at': created_at,
      'updated_at': updated_at,
      'favorite': favorite ? 1 : 0, // 1 or 0
    };
  }

  factory CardType.fromMap(Map<dynamic, dynamic> map) {
    return CardType(
      id: map['id'] ?? 0, // ?没创建id？不对吧
      title: map['title'],
      contentList: map['contentList'] != null
        ? List<CheckListItemType>.from(
            jsonDecode(
              map['contentList']).map((x) => CheckListItemType.fromMap(x)
            )
          )
        : [],
      created_at: map['created_at'] ?? 0,
      updated_at: map['updated_at'] ?? 0,
      favorite: map['favorite'] == 1 ? true : false,
    );
  }
}
