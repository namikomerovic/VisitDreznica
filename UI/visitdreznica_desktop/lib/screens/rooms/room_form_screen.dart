import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/adaptive_row.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/error_view.dart';
import '../../widgets/image_gallery.dart';

class RoomFormScreen extends StatefulWidget {
  const RoomFormScreen({super.key, this.roomId});

  final int? roomId;

  @override
  State<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends State<RoomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();
  final _areaController = TextEditingController();
  final _priceController = TextEditingController();

  late final RoomService _rooms;
  late final LookupService _roomTypesService;
  late final LookupService _amenitiesService;

  int? _roomId;
  int? _roomTypeId;
  bool _isActive = true;
  final Set<int> _amenityIds = {};
  List<LookupItem> _roomTypes = [];
  List<LookupItem> _amenities = [];
  List<GalleryImage> _images = [];

  bool _loading = true;
  bool _saving = false;
  bool _changed = false;
  String? _loadError;
  Map<String, String> _serverErrors = {};

  bool get _isEdit => _roomId != null;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _rooms = RoomService(api);
    _roomTypesService = LookupService(api, 'RoomTypes');
    _amenitiesService = LookupService(api, 'Amenities');
    _roomId = widget.roomId;
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    _areaController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final roomTypes = await _roomTypesService.getAll();
      final amenities = await _amenitiesService.getAll();
      final room = _roomId == null ? null : await _rooms.getById(_roomId!);

      if (!mounted) return;

      setState(() {
        _roomTypes = roomTypes;
        _amenities = amenities;
        if (room != null) _fill(room);
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fill(Room room) {
    _roomId = room.id;
    _nameController.text = room.name;
    _descriptionController.text = room.description ?? '';
    _capacityController.text = '${room.capacity}';
    _areaController.text = '${room.areaSquareMeters}';
    _priceController.text = room.pricePerNight.toStringAsFixed(2).replaceAll('.', ',');
    _roomTypeId = room.roomTypeId;
    _isActive = room.isActive;
    _amenityIds
      ..clear()
      ..addAll(room.amenities.map((x) => x.id));
    _images = room.images;
  }

  Future<void> _save() async {
    setState(() => _serverErrors = {});

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = RoomUpsertRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      roomTypeId: _roomTypeId!,
      capacity: int.parse(_capacityController.text),
      areaSquareMeters: int.parse(_areaController.text),
      pricePerNight: _parseDecimal(_priceController.text)!,
      isActive: _isActive,
      amenityIds: _amenityIds.toList(),
    );

    setState(() => _saving = true);

    try {
      final wasNew = !_isEdit;
      final saved = wasNew ? await _rooms.insert(request) : await _rooms.update(_roomId!, request);

      if (!mounted) return;

      setState(() {
        _changed = true;
        _fill(saved);
      });

      showMessage(context, wasNew ? tr.roomAddedAddImages : tr.changesSaved);
      if (!wasNew) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.fieldErrors.isNotEmpty) {
        setState(() => _serverErrors = {
              for (final entry in e.fieldErrors.entries)
                entry.key.replaceFirst(r'$.', '').toLowerCase(): entry.value.first,
            });
      } else {
        showMessage(context, e.message, isError: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showConfirmDialog(
      context,
      title: tr.deletingRoom,
      message: tr.deleteRoomQuestion(_nameController.text),
      confirmLabel: tr.delete,
      destructive: true,
    );

    if (!confirmed) return;

    try {
      await _rooms.delete(_roomId!);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    }
  }

  Future<void> _reloadImages() async {
    final room = await _rooms.getById(_roomId!);
    if (!mounted) return;
    setState(() {
      _images = room.images;
      _changed = true;
    });
  }

  String? _serverError(String field) => _serverErrors[field.toLowerCase()];

  static double? _parseDecimal(String? value) =>
      value == null ? null : double.tryParse(value.trim().replaceAll(',', '.'));

  static String? _intInRange(String? value, int min, int max, String message) {
    final number = int.tryParse(value?.trim() ?? '');
    return number == null || number < min || number > max ? message : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: tr.back,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _changed),
        ),
        title: Text(_isEdit ? _nameController.text : tr.newRoom),
        actions: [
          if (_isEdit)
            TextButton.icon(
              onPressed: _saving ? null : _delete,
              icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              label: Text(tr.delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null) {
      return ErrorView(message: _loadError!, onRetry: _load);
    }

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AdaptiveRow(
                      breakpoint: 800,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildFields()),
                        const SizedBox(width: 32),
                        Expanded(flex: 2, child: _buildAmenities(theme)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr.images, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(tr.imagesHint,
                            style: theme.textTheme.bodySmall),
                        const SizedBox(height: 16),
                        if (_isEdit)
                          ImageGallery(
                            images: _images,
                            imageUrl: _rooms.imageUrl,
                            onUpload: (Uint8List bytes, String name, String type) async {
                              await _rooms.uploadImage(_roomId!, bytes, name, type);
                              await _reloadImages();
                            },
                            onSetCover: (imageId) async {
                              await _rooms.setCoverImage(imageId);
                              await _reloadImages();
                            },
                            onDelete: (imageId) async {
                              await _rooms.deleteImage(imageId);
                              await _reloadImages();
                            },
                          )
                        else
                          Text(tr.imagesAfterSaveRoom),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save_outlined),
                    label: Text(_isEdit ? tr.saveChanges : tr.addRoom),
                    style: FilledButton.styleFrom(minimumSize: const Size(180, 48)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFields() {
    final digitsOnly = [FilteringTextInputFormatter.digitsOnly];

    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          maxLength: 100,
          decoration: InputDecoration(
            labelText: tr.nameRequired,
            border: const OutlineInputBorder(),
            errorText: _serverError('name'),
          ),
          validator: (value) {
            final length = value?.trim().length ?? 0;
            return length < 3 || length > 100 ? tr.nameLength3to100 : null;
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _roomTypeId,
          decoration: InputDecoration(
            labelText: tr.roomTypeRequired,
            border: const OutlineInputBorder(),
            errorText: _serverError('roomTypeId'),
          ),
          items: [for (final type in _roomTypes) DropdownMenuItem(value: type.id, child: Text(type.name))],
          onChanged: (value) => setState(() => _roomTypeId = value),
          validator: (value) => value == null ? tr.selectRoomType : null,
        ),
        const SizedBox(height: 16),
        AdaptiveRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _capacityController,
                inputFormatters: digitsOnly,
                decoration: InputDecoration(
                  labelText: tr.capacityPeopleRequired,
                  border: const OutlineInputBorder(),
                  errorText: _serverError('capacity'),
                ),
                validator: (value) => _intInRange(value, 1, 10, tr.between1and10People),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _areaController,
                inputFormatters: digitsOnly,
                decoration: InputDecoration(
                  labelText: tr.areaRequired,
                  border: const OutlineInputBorder(),
                  errorText: _serverError('areaSquareMeters'),
                ),
                validator: (value) => _intInRange(value, 5, 200, tr.between5and200m2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _priceController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                decoration: InputDecoration(
                  labelText: tr.pricePerNightRequired,
                  hintText: tr.priceExample,
                  border: const OutlineInputBorder(),
                  errorText: _serverError('pricePerNight'),
                ),
                validator: (value) {
                  final price = _parseDecimal(value);
                  return price == null || price < 1 || price > 10000 ? tr.priceNightRange : null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          maxLength: 1000,
          decoration: InputDecoration(
            labelText: tr.description,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
            errorText: _serverError('description'),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenities(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.roomAmenities, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final amenity in _amenities)
              FilterChip(
                label: Text(amenity.name),
                selected: _amenityIds.contains(amenity.id),
                onSelected: (selected) => setState(
                  () => selected ? _amenityIds.add(amenity.id) : _amenityIds.remove(amenity.id),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(tr.activeFemale),
          subtitle: Text(tr.inactiveRoomsHint),
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
        ),
      ],
    );
  }
}