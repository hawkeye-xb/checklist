class ContentList {
  String id;
  String content;
  bool checked;

  ContentList({
    required this.id,
    required this.content,
    this.checked = false,
  });
}

class CardType {
  String title;
  List<ContentList> contentList;
  String id;

  CardType({
    required this.title,
    this.contentList = const [],
    required this.id
  });
}
