import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/item_type_ui.dart';
import '../details/item_navigation.dart';
import 'explore_card.dart';
import 'explore_item.dart';
import '../map/places_map_screen.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key, required this.selectedType});

  final ValueNotifier<ItemType> selectedType;

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final _searchController = TextEditingController();
  late final ExploreLoader _loader;
  late final ReviewService _reviews;

  Timer? _debounce;
  bool _loading = true;
  String? _error;
  List<ExploreItem> _items = [];
  Map<int, ReviewSummaryItem> _ratings = {};
  int _requestId = 0;

  ItemType get _type => widget.selectedType.value;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _loader = ExploreLoader(api);
    _reviews = ReviewService(api);
    widget.selectedType.addListener(_onTypeChanged);
    _load();
  }

  @override
  void dispose() {
    widget.selectedType.removeListener(_onTypeChanged);
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onTypeChanged() {
    _searchController.clear();
    _load();
  }

  Future<void> _load() async {
    final requestId = ++_requestId;
    final type = _type;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await _loader.load(type, _searchController.text);
      final ratings = await _reviews.getSummaries(type);

      if (!mounted || requestId != _requestId) return;
      setState(() {
        _items = items;
        _ratings = ratings;
      });
    } on ApiException catch (e) {
      if (mounted && requestId == _requestId) setState(() => _error = e.message);
    } finally {
      if (mounted && requestId == _requestId) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SegmentedButton<ItemType>(
            showSelectedIcon: false,
            segments: [
              for (final type in ItemType.values)
                ButtonSegment(value: type, icon: Icon(type.icon), tooltip: type.pluralLabel),
            ],
            selected: {_type},
            onSelectionChanged: (selection) => widget.selectedType.value = selection.first,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: (_) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 400), _load);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Pretraži: ${_type.pluralLabel.toLowerCase()}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              if (_type == ItemType.place) ...[
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Prikaži na mapi',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const PlacesMapScreen()),
                  ),
                  icon: const Icon(Icons.map_outlined),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _load, child: const Text('Pokušaj ponovo')),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: _items.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('Nema rezultata.')),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ExploreCard(
                  item: item,
                  rating: _ratings[item.id],
                  onTap: () => openItemDetails(context, item.type, item.id),
                );
              },
            ),
    );
  }
}