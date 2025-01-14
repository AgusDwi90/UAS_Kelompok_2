import 'package:flutter/foundation.dart';
import '../models/music.dart';
import '../services/database_helper.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Music> _favorites = [];

  List<Music> get favorites => _favorites;

  Future<void> loadFavorites() async {
    final favs = await DatabaseHelper.instance.getFavorites();
    _favorites.clear();
    _favorites.addAll(favs);
    notifyListeners();
  }

  Future<void> toggleFavorite(Music music) async {
    final isExist = _favorites.any((element) => element.id == music.id);
    if (isExist) {
      await DatabaseHelper.instance.deleteFavorite(music.id);
      _favorites.removeWhere((element) => element.id == music.id);
    } else {
      await DatabaseHelper.instance.insertFavorite(music);
      _favorites.add(music..isFavorite = true);
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((element) => element.id == id);
  }
}