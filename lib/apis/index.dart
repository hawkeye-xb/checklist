import 'package:checklist/apis/databaseHelper.dart';

Future<void> updateFavorite(int id, bool favorite) async {
  DatabaseHelper helper = DatabaseHelper();
  var cardType = await helper.getCardType(id);
  if (cardType != null) {
    cardType.favorite = favorite;
    await helper.updateCardType(cardType);
  }
}
