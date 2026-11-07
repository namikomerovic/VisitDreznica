import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';


import '../../widgets/dialogs.dart';
import '../../widgets/error_view.dart';
import '../../widgets/image_gallery.dart';
import '../../widgets/location_picker.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({super.key, this.placeId});

  final int? placeId;

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mapKey = GlobalKey<LocationPickerState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  late final PlaceService _service;
  late final LookupService _typesService;

  Place? _place;
  int? _typeId;
  bool _isActive = true;
  LatLng? _location;
  List<LookupItem> _types = [];
  List<GalleryImage> _images = [];

  bool _loading = true;
  bool _saving = false;
  bool _changed = false;
  String? _loadError;
  Map<String, String> _serverErrors = {};

  bool get _isEdit => _place != null;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = PlaceService(api);
    _typesService = LookupService(api, 'PlaceTypes');
    _load();
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _descriptionController,
      _addressController,
      _latitudeController,
      _longitudeController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final types = await _typesService.getAll();
      final place = widget.placeId == null ? null : await _service.getById(widget.placeId!);

      if (!mounted) return;

      setState(() {
        _types = types;
        if (place != null) _fill(place);
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fill(Place place) {
    _place = place;
    _nameController.text = place.name;
    _descriptionController.text = place.description ?? '';
    _addressController.text = place.address ?? '';
    _typeId = place.placeTypeId;
    _isActive = place.isActive;
    _images = place.images;
    _setLocation(LatLng(place.latitude, place.longitude), updateFields: true);
  }

  void _setLocation(LatLng point, {required bool updateFields}) {
    _location = point;

    if (updateFields) {
      _latitudeController.text = point.latitude.toStringAsFixed(6);
      _longitudeController.text = point.longitude.toStringAsFixed(6);
    }
  }

  void _onMapTap(LatLng point) => setState(() => _setLocation(point, updateFields: true));

  void _onCoordinatesTyped() {
    final latitude = parseDecimal(_latitudeController.text);
    final longitude = parseDecimal(_longitudeController.text);

    if (latitude == null || longitude == null || latitude.abs() > 90 || longitude.abs() > 180) {
      return;
    }

    final point = LatLng(latitude, longitude);
    setState(() => _setLocation(point, updateFields: false));
    _mapKey.currentState?.centerOn(point);
  }

  String? _optional(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  Future<void> _save() async {
    setState(() => _serverErrors = {});

    if (!_formKey.currentState!.validate()) return;

    final request = PlaceUpsertRequest(
      name: _nameController.text.trim(),
      description: _optional(_descriptionController),
      placeTypeId: _typeId!,
      latitude: parseDecimal(_latitudeController.text)!,
      longitude: parseDecimal(_longitudeController.text)!,
      address: _optional(_addressController),
      isActive: _isActive,
    );

    setState(() => _saving = true);

    try {
      final wasNew = !_isEdit;
      final saved = wasNew ? await _service.insert(request) : await _service.update(_place!.id, request);

      if (!mounted) return;

      setState(() {
        _changed = true;
        _fill(saved);
      });

      showMessage(
        context,
        wasNew
            ? 'Mjesto je dodano (${Formatters.decimal(saved.distanceKm)} km od smještaja). Sada možete dodati slike.'
            : 'Izmjene su sačuvane.',
      );
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.fieldErrors.isNotEmpty) {
        setState(() => _serverErrors = normalizeServerErrors(e.fieldErrors));
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
      title: 'Brisanje mjesta',
      message: 'Obrisati "${_place!.name}"? Ovo se ne može poništiti.\n\n'
          'Ako mjesto ima recenzije ili je u favoritima gostiju, brisanje nije moguće. Tada ga označite kao neaktivno.',
      confirmLabel: 'Obriši',
      destructive: true,
    );

    if (!confirmed) return;

    try {
      await _service.delete(_place!.id);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    }
  }

  Future<void> _reloadImages() async {
    final place = await _service.getById(_place!.id);
    if (!mounted) return;
    setState(() {
      _images = place.images;
      _changed = true;
    });
  }

  String? _serverError(String field) => _serverErrors[field.toLowerCase()];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Nazad',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _changed),
        ),
        title: Text(_place?.name ?? 'Novo mjesto'),
        actions: [
          if (_isEdit)
            TextButton.icon(
              onPressed: _saving ? null : _delete,
              icon: Icon(Icons.delete_outline, color: scheme.error),
              label: Text('Obriši', style: TextStyle(color: scheme.error)),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) return ErrorView(message: _loadError!, onRetry: _load);

    final theme = Theme.of(context);
    final coordinateFormatter = [FilteringTextInputFormatter.allow(RegExp(r'[-0-9.,]'))];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                maxLength: 150,
                                decoration: InputDecoration(
                                  labelText: 'Naziv *',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('name'),
                                ),
                                validator: (value) =>
                                    validateLength(value, 3, 150, 'Naziv mora imati između 3 i 150 znakova.'),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<int>(
                                initialValue: _typeId,
                                decoration: InputDecoration(
                                  labelText: 'Tip mjesta *',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('placeTypeId'),
                                ),
                                items: [for (final type in _types) DropdownMenuItem(value: type.id, child: Text(type.name))],
                                onChanged: (value) => setState(() => _typeId = value),
                                validator: (value) => value == null ? 'Odaberite tip mjesta.' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _addressController,
                                maxLength: 200,
                                decoration: InputDecoration(
                                  labelText: 'Adresa / naselje',
                                  hintText: 'npr. Donja Drežnica',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('address'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _latitudeController,
                                      inputFormatters: coordinateFormatter,
                                      onChanged: (_) => _onCoordinatesTyped(),
                                      decoration: InputDecoration(
                                        labelText: 'Geografska širina *',
                                        border: const OutlineInputBorder(),
                                        errorText: _serverError('latitude'),
                                      ),
                                      validator: (value) => validateDecimalRange(
                                          value, -90, 90, 'Odaberite lokaciju na karti.'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _longitudeController,
                                      inputFormatters: coordinateFormatter,
                                      onChanged: (_) => _onCoordinatesTyped(),
                                      decoration: InputDecoration(
                                        labelText: 'Geografska dužina *',
                                        border: const OutlineInputBorder(),
                                        errorText: _serverError('longitude'),
                                      ),
                                      validator: (value) => validateDecimalRange(
                                          value, -180, 180, 'Odaberite lokaciju na karti.'),
                                    ),
                                  ),
                                ],
                              ),
                              if (_place != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Udaljenost od smještaja: ${Formatters.decimal(_place!.distanceKm)} km',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 5,
                                maxLength: 2000,
                                decoration: InputDecoration(
                                  labelText: 'Opis',
                                  alignLabelWithHint: true,
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('description'),
                                ),
                              ),
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Aktivno'),
                                subtitle: const Text('Neaktivna mjesta gosti ne vide.'),
                                value: _isActive,
                                onChanged: (value) => setState(() => _isActive = value),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: LocationPicker(key: _mapKey, value: _location, onChanged: _onMapTap, height: 520),
                        ),
                      ],
                    ),
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
                      Text('Slike', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      if (_place != null)
                        ImageGallery(
                          images: _images,
                          imageUrl: _service.imageUrl,
                          onUpload: (Uint8List bytes, String name, String type) async {
                            await _service.uploadImage(_place!.id, bytes, name, type);
                            await _reloadImages();
                          },
                          onSetCover: (imageId) async {
                            await _service.setCoverImage(imageId);
                            await _reloadImages();
                          },
                          onDelete: (imageId) async {
                            await _service.deleteImage(imageId);
                            await _reloadImages();
                          },
                        )
                      else
                        const Text('Slike možete dodati nakon što sačuvate mjesto.'),
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
                  label: Text(_isEdit ? 'Sačuvaj izmjene' : 'Dodaj mjesto'),
                  style: FilledButton.styleFrom(minimumSize: const Size(180, 48)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}