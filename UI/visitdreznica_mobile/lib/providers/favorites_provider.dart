import 'package:flutter/foundation.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(ApiClient api) : _service = FavoriteService(api);

  final FavoriteService _service;
  final Set<String> _busy = {};

  List<Favorite> _items = [];
  bool _loading = false;
  String? _error;

  List<Favorite> get items => List.unmodifiable(_items);
  bool get isLoading => _loading;
  String? get error => _error;

  static String _key(ItemType type, int id) => '${type.value}:$id';

  bool isFavorite(ItemType type, int id) => _items.any((x) => x.itemType == type && x.itemId == id);

  bool isBusy(ItemType type, int id) => _busy.contains(_key(type, id));

  Future<void> load() async {
    _items = [];
    _loading = true;
    _error = null;

    try {
      _items = await _service.getMine();
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> toggle(ItemType type, int id) async {
    final key = _key(type, id);
    if (!_busy.add(key)) return;
    notifyListeners();

    try {
      if (isFavorite(type, id)) {
        await _service.remove(type, id);
        _items = _items.where((x) => !(x.itemType == type && x.itemId == id)).toList();
      } else {
        final favorite = await _service.add(type, id);
        _items = [favorite, ..._items];
      }
    } finally {
      _busy.remove(key);
      notifyListeners();
    }
  }
}