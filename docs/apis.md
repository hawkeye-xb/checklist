### 存储结构
```dart
class ContentList {
	id: string;
	content: string;
	checked: bool;
	created: int;
}

class CardType {
	id: string;
	contentList: List<ContentList>;
	title: string;
	collected: bool;
	created: int;
	updated: int;
}
```