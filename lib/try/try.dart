import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String cartKey = 'cart_items';
  static const String favoritesKey = 'favorite_items';
  
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  Future<void> saveCartItems(List<String> items) async {
    await _prefs.setStringList(cartKey, items);
  }

  List<String> getCartItems() {
    return _prefs.getStringList(cartKey) ?? [];
  }

  Future<void> saveFavoriteItems(List<String> items) async {
    await _prefs.setStringList(favoritesKey, items);
  }

  List<String> getFavoriteItems() {
    return _prefs.getStringList(favoritesKey) ?? [];
  }
}
