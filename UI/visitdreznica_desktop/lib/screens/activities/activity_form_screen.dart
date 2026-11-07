import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';


import '../../widgets/dialogs.dart';
import '../../widgets/error_view.dart';
import '../../widgets/single_image_editor.dart';
import 'activity_slots_section.dart';

class ActivityFormScreen extends StatefulWidget {
  const ActivityFormScreen({super.key, this.activityId});

  final int? activityId;

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  final _priceController = TextEditingController();
  final _meetingPointController = TextEditingController();

  late final ActivityService _service;
  late final LookupService _categoriesService;
  late final GuideService _guideService;

  Activity? _activity;
  int? _categoryId;
  bool _isActive = true;
  List<LookupItem> _categories = [];
  List<Guide> _guides = [];

  bool _loading = true;
  bool _saving = false;
  bool _changed = false;
  String? _loadError;
  Map<String, String> _serverErrors = {};

  bool get _isEdit => _activity != null;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = ActivityService(api);
    _categoriesService = LookupService(api, 'ActivityCategories');
    _guideService = GuideService(api);
    _load();
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _descriptionController,
      _durationController,
      _maxParticipantsController,
      _priceController,
      _meetingPointController,
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
      final categories = await _categoriesService.getAll();
      final guides = await _guideService.getAll();
      final id = _activity?.id ?? widget.activityId;
      final activity = id == null ? null : await _service.getById(id);

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _guides = guides;
        if (activity != null) _fill(activity);
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fill(Activity activity) {
    _activity = activity;
    _nameController.text = activity.name;
    _descriptionController.text = activity.description ?? '';
    _durationController.text = '${activity.durationMinutes}';
    _maxParticipantsController.text = '${activity.maxParticipants}';
    _priceController.text = formatDecimal(activity.pricePerPerson);
    _meetingPointController.text = activity.meetingPoint ?? '';
    _categoryId = activity.activityCategoryId;
    _isActive = activity.isActive;
  }

  String? _optional(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  Future<void> _save() async {
    setState(() => _serverErrors = {});

    if (!_formKey.currentState!.validate()) return;

    final request = ActivityUpsertRequest(
      name: _nameController.text.trim(),
      description: _optional(_descriptionController),
      activityCategoryId: _categoryId!,
      durationMinutes: int.parse(_durationController.text),
      maxParticipants: int.parse(_maxParticipantsController.text),
      pricePerPerson: parseDecimal(_priceController.text)!,
      meetingPoint: _optional(_meetingPointController),
      isActive: _isActive,
    );

    setState(() => _saving = true);

    try {
      final wasNew = !_isEdit;
      final saved = wasNew ? await _service.insert(request) : await _service.update(_activity!.id, request);

      if (!mounted) return;

      setState(() {
        _changed = true;
        _fill(saved);
      });

      showMessage(context, wasNew ? 'Aktivnost je dodana. Sada možete dodati sliku i termine.' : 'Izmjene su sačuvane.');
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
      title: 'Brisanje aktivnosti',
      message: 'Obrisati "${_activity!.name}"? Ovo se ne može poništiti.\n\n'
          'Ako aktivnost ima termine ili rezervacije, brisanje nije moguće. Tada je umjesto toga označite kao neaktivnu.',
      confirmLabel: 'Obriši',
      destructive: true,
    );

    if (!confirmed) return;

    try {
      await _service.delete(_activity!.id);
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
        title: Text(_activity?.name ?? 'Nova aktivnost'),
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
    final digitsOnly = [FilteringTextInputFormatter.digitsOnly];
    final activity = _activity;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
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
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<int>(
                                initialValue: _categoryId,
                                decoration: InputDecoration(
                                  labelText: 'Kategorija *',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('activityCategoryId'),
                                ),
                                items: [
                                  for (final category in _categories)
                                    DropdownMenuItem(value: category.id, child: Text(category.name)),
                                ],
                                onChanged: (value) => setState(() => _categoryId = value),
                                validator: (value) => value == null ? 'Odaberite kategoriju.' : null,
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
                                controller: _durationController,
                                inputFormatters: digitsOnly,
                                decoration: InputDecoration(
                                  labelText: 'Trajanje (minuta) *',
                                  helperText: 'npr. 180 = 3 sata',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('durationMinutes'),
                                ),
                                validator: (value) => validateIntRange(value, 30, 720, 'Između 30 i 720 minuta.'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _maxParticipantsController,
                                inputFormatters: digitsOnly,
                                decoration: InputDecoration(
                                  labelText: 'Max učesnika *',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('maxParticipants'),
                                ),
                                validator: (value) => validateIntRange(value, 1, 50, 'Između 1 i 50.'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                inputFormatters: [decimalInputFormatter],
                                decoration: InputDecoration(
                                  labelText: 'Cijena po osobi (KM) *',
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError('pricePerPerson'),
                                ),
                                validator: (value) => validateDecimalRange(value, 1, 1000, 'Između 1 i 1.000 KM.'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _meetingPointController,
                          maxLength: 200,
                          decoration: InputDecoration(
                            labelText: 'Mjesto okupljanja',
                            hintText: 'npr. Plaža ispred smještaja',
                            border: const OutlineInputBorder(),
                            errorText: _serverError('meetingPoint'),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
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
                          title: const Text('Aktivna'),
                          subtitle: const Text('Neaktivnu aktivnost gosti ne vide i ne mogu je rezervisati.'),
                          value: _isActive,
                          onChanged: (value) => setState(() => _isActive = value),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _save,
                            icon: _saving
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.save_outlined),
                            label: Text(_isEdit ? 'Sačuvaj izmjene' : 'Dodaj aktivnost'),
                            style: FilledButton.styleFrom(minimumSize: const Size(180, 48)),
                          ),
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
                      Text('Slika', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      if (activity != null)
                        SingleImageEditor(
                          imageUrl: _service.imageUrl(activity.id),
                          hasImage: activity.hasImage,
                          placeholderIcon: Icons.hiking_outlined,
                          onUpload: (bytes, name, type) async {
                            await _service.setImage(activity.id, bytes, name, type);
                            _changed = true;
                            await _load();
                          },
                          onDelete: () async {
                            await _service.deleteImage(activity.id);
                            _changed = true;
                            await _load();
                          },
                        )
                      else
                        const Text('Sliku možete dodati nakon što sačuvate aktivnost.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: activity == null
                      ? const Text('Termine možete dodati nakon što sačuvate aktivnost.')
                      : ActivitySlotsSection(
                          key: ValueKey('slots-${activity.id}-${activity.durationMinutes}-${activity.maxParticipants}'),
                          activity: activity,
                          guides: _guides,
                          onChanged: () => _changed = true,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}