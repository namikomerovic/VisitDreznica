import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/form_helpers.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/error_view.dart';
import '../../widgets/single_image_editor.dart';

class EquipmentFormScreen extends StatefulWidget {
  const EquipmentFormScreen({super.key, this.equipmentId});

  final int? equipmentId;

  @override
  State<EquipmentFormScreen> createState() => _EquipmentFormScreenState();
}

class _EquipmentFormScreenState extends State<EquipmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();
  final _quantityController = TextEditingController();
  final _firstHourController = TextEditingController();
  final _additionalHourController = TextEditingController();
  final _fullDayController = TextEditingController();

  late final EquipmentService _service;
  late final LookupService _typesService;

  int? _id;
  int? _typeId;
  bool _isActive = true;
  bool _hasImage = false;
  List<LookupItem> _types = [];

  bool _loading = true;
  bool _saving = false;
  bool _changed = false;
  String? _loadError;
  Map<String, String> _serverErrors = {};

  bool get _isEdit => _id != null;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = EquipmentService(api);
    _typesService = LookupService(api, 'EquipmentTypes');
    _id = widget.equipmentId;
    _load();
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _descriptionController,
      _capacityController,
      _quantityController,
      _firstHourController,
      _additionalHourController,
      _fullDayController,
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
      final item = _id == null ? null : await _service.getById(_id!);

      if (!mounted) return;

      setState(() {
        _types = types;
        if (item != null) _fill(item);
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fill(Equipment item) {
    _id = item.id;
    _nameController.text = item.name;
    _descriptionController.text = item.description ?? '';
    _capacityController.text = '${item.capacity}';
    _quantityController.text = '${item.totalQuantity}';
    _firstHourController.text = formatDecimal(item.firstHourPrice);
    _additionalHourController.text = formatDecimal(item.additionalHourPrice);
    _fullDayController.text = formatDecimal(item.fullDayPrice);
    _typeId = item.equipmentTypeId;
    _isActive = item.isActive;
    _hasImage = item.hasImage;
  }

  Future<void> _save() async {
    setState(() => _serverErrors = {});

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final description = _descriptionController.text.trim();
    final request = EquipmentUpsertRequest(
      name: _nameController.text.trim(),
      description: description.isEmpty ? null : description,
      equipmentTypeId: _typeId!,
      capacity: int.parse(_capacityController.text),
      totalQuantity: int.parse(_quantityController.text),
      firstHourPrice: parseDecimal(_firstHourController.text)!,
      additionalHourPrice: parseDecimal(_additionalHourController.text)!,
      fullDayPrice: parseDecimal(_fullDayController.text)!,
      isActive: _isActive,
    );

    setState(() => _saving = true);

    try {
      final wasNew = !_isEdit;
      final saved = wasNew ? await _service.insert(request) : await _service.update(_id!, request);

      if (!mounted) return;

      setState(() {
        _changed = true;
        _fill(saved);
      });

      showMessage(context, wasNew ? 'Oprema je dodana. Sada možete dodati sliku.' : 'Izmjene su sačuvane.');
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
      title: 'Brisanje opreme',
      message: 'Obrisati "${_nameController.text}"? Ovo se ne može poništiti.\n\n'
          'Ako oprema ima rezervacije, brisanje nije moguće. Tada je umjesto toga označite kao neaktivnu.',
      confirmLabel: 'Obriši',
      destructive: true,
    );

    if (!confirmed) return;

    try {
      await _service.delete(_id!);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    }
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
        title: Text(_isEdit ? _nameController.text : 'Nova oprema'),
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null) {
      return ErrorView(message: _loadError!, onRetry: _load);
    }

    final theme = Theme.of(context);
    final digitsOnly = [FilteringTextInputFormatter.digitsOnly];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _nameController,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  labelText: 'Naziv *',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('name'),
                                ),
                                validator: (value) =>
                                    validateLength(value, 3, 100, 'Naziv mora imati između 3 i 100 znakova.'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<int>(
                                initialValue: _typeId,
                                decoration: InputDecoration(
                                  labelText: 'Tip opreme *',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('equipmentTypeId'),
                                ),
                                items: [
                                  for (final type in _types) DropdownMenuItem(value: type.id, child: Text(type.name)),
                                ],
                                onChanged: (value) => setState(() => _typeId = value),
                                validator: (value) => value == null ? 'Odaberite tip opreme.' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _capacityController,
                                inputFormatters: digitsOnly,
                                decoration: InputDecoration(
                                  labelText: 'Osoba po komadu *',
                                  helperText: 'npr. 2 za kajak dvosjed',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('capacity'),
                                ),
                                validator: (value) => validateIntRange(value, 1, 4, 'Između 1 i 4.'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _quantityController,
                                inputFormatters: digitsOnly,
                                decoration: InputDecoration(
                                  labelText: 'Ukupno komada *',
                                  helperText: 'koliko ih imate na raspolaganju',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('totalQuantity'),
                                ),
                                validator: (value) => validateIntRange(value, 1, 100, 'Između 1 i 100.'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _priceField(_firstHourController, 'Prvi sat (KM) *', 'firstHourPrice')),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _priceField(_additionalHourController, 'Svaki sljedeći sat (KM) *', 'additionalHourPrice'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: _priceField(_fullDayController, 'Cijeli dan (KM) *', 'fullDayPrice')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _PricePreview(
                          firstHour: parseDecimal(_firstHourController.text),
                          additionalHour: parseDecimal(_additionalHourController.text),
                          fullDay: parseDecimal(_fullDayController.text),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          maxLength: 1000,
                          decoration: InputDecoration(
                            labelText: 'Opis',
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(),
                            errorText: _serverError('description'),
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Aktivna'),
                          subtitle: const Text('Neaktivnu opremu gosti ne vide i ne mogu je rezervisati.'),
                          value: _isActive,
                          onChanged: (value) => setState(() => _isActive = value),
                        ),
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
                        Text('Slika', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 16),
                        if (_isEdit)
                          SingleImageEditor(
                            imageUrl: _service.imageUrl(_id!),
                            hasImage: _hasImage,
                            placeholderIcon: Icons.kayaking_outlined,
                            onUpload: (bytes, name, type) async {
                              await _service.setImage(_id!, bytes, name, type);
                              setState(() {
                                _hasImage = true;
                                _changed = true;
                              });
                            },
                            onDelete: () async {
                              await _service.deleteImage(_id!);
                              setState(() {
                                _hasImage = false;
                                _changed = true;
                              });
                            },
                          )
                        else
                          const Text('Sliku možete dodati nakon što sačuvate opremu.'),
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
                    label: Text(_isEdit ? 'Sačuvaj izmjene' : 'Dodaj opremu'),
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

  Widget _priceField(TextEditingController controller, String label, String field) {
    return TextFormField(
      controller: controller,
      inputFormatters: [decimalInputFormatter],
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: _serverError(field),
      ),
      validator: (value) => validateDecimalRange(value, 1, 1000, 'Između 1 i 1.000 KM.'),
    );
  }
}

class _PricePreview extends StatelessWidget {
  const _PricePreview({required this.firstHour, required this.additionalHour, required this.fullDay});

  final double? firstHour;
  final double? additionalHour;
  final double? fullDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (firstHour == null || additionalHour == null || fullDay == null) {
      return const SizedBox.shrink();
    }

    final parts = [
      for (final hours in [1, 2, 3, 4])
        '$hours h: ${Formatters.money(EquipmentPricing.priceFor(hours, firstHour: firstHour!, additionalHour: additionalHour!, fullDay: fullDay!))}',
      'cijeli dan: ${Formatters.money(fullDay!)}',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('Gost plaća po komadu: ${parts.join('  ·  ')}', style: theme.textTheme.bodyMedium),
    );
  }
}