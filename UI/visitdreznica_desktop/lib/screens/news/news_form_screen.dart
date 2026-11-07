import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/form_helpers.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/error_view.dart';
import '../../widgets/single_image_editor.dart';

class NewsFormScreen extends StatefulWidget {
  const NewsFormScreen({super.key, this.newsId});

  final int? newsId;

  @override
  State<NewsFormScreen> createState() => _NewsFormScreenState();
}

class _NewsFormScreenState extends State<NewsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late final NewsService _service;

  NewsItem? _item;
  DateTime _publishedAt = DateTime.now();

  bool _loading = true;
  bool _saving = false;
  bool _changed = false;
  String? _loadError;
  Map<String, String> _serverErrors = {};

  bool get _isEdit => _item != null;
  bool get _isScheduled => _publishedAt.isAfter(DateTime.now());

  @override
  void initState() {
    super.initState();
    _service = NewsService(context.read<ApiClient>());
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = _item?.id ?? widget.newsId;

    if (id == null) {
      setState(() => _loading = false);
      return;
    }

    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final item = await _service.getById(id);
      if (mounted) setState(() => _fill(item));
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fill(NewsItem item) {
    _item = item;
    _titleController.text = item.title;
    _contentController.text = item.content;
    _publishedAt = item.publishedAt.toLocal();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDate: _publishedAt,
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_publishedAt));

    if (time == null) return;

    setState(() => _publishedAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    setState(() => _serverErrors = {});

    if (!_formKey.currentState!.validate()) return;

    final request = NewsUpsertRequest(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      publishedAt: _publishedAt,
    );

    setState(() => _saving = true);

    try {
      final wasNew = !_isEdit;
      final saved = wasNew ? await _service.insert(request) : await _service.update(_item!.id, request);

      if (!mounted) return;

      setState(() {
        _changed = true;
        _fill(saved);
      });

      final status = saved.isPublished ? 'objavljena' : 'zakazana za ${Formatters.dateTime(saved.publishedAt)}';
      showMessage(context, wasNew ? 'Novost je $status. Sada možete dodati sliku.' : 'Izmjene su sačuvane.');
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
      title: 'Brisanje novosti',
      message: 'Obrisati "${_item!.title}"? Ovo se ne može poništiti.',
      confirmLabel: 'Obriši',
      destructive: true,
    );

    if (!confirmed) return;

    try {
      await _service.delete(_item!.id);
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
        title: Text(_isEdit ? 'Novost' : 'Nova novost'),
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
    final item = _item;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          maxLength: 150,
                          decoration: InputDecoration(
                            labelText: 'Naslov *',
                            border: const OutlineInputBorder(),
                            errorText: _serverError('title'),
                          ),
                          validator: (value) =>
                              validateLength(value, 3, 150, 'Naslov mora imati između 3 i 150 znakova.'),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _contentController,
                          minLines: 8,
                          maxLines: 16,
                          maxLength: 4000,
                          decoration: InputDecoration(
                            labelText: 'Tekst *',
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(),
                            errorText: _serverError('content'),
                          ),
                          validator: (value) =>
                              validateLength(value, 10, 4000, 'Tekst mora imati između 10 i 4000 znakova.'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: _saving ? null : _pickDateTime,
                              icon: const Icon(Icons.event),
                              label: Text('Objava: ${Formatters.dateTime(_publishedAt)}'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: _saving ? null : () => setState(() => _publishedAt = DateTime.now()),
                              child: const Text('Odmah'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isScheduled
                                    ? 'Zakazano: gosti će novost vidjeti tek od odabranog trenutka.'
                                    : 'Gosti vide novost odmah nakon čuvanja.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _isScheduled ? const Color(0xFFB45309) : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (item != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text('Autor: ${item.createdByFullName}', style: theme.textTheme.bodySmall),
                          ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _save,
                            icon: _saving
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                : Icon(_isScheduled ? Icons.schedule_send_outlined : Icons.send_outlined),
                            label: Text(_isEdit ? 'Sačuvaj izmjene' : (_isScheduled ? 'Zakaži' : 'Objavi')),
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
                      if (item != null)
                        SingleImageEditor(
                          imageUrl: _service.imageUrl(item.id),
                          hasImage: item.hasImage,
                          placeholderIcon: Icons.newspaper_outlined,
                          onUpload: (bytes, name, type) async {
                            await _service.setImage(item.id, bytes, name, type);
                            _changed = true;
                            await _load();
                          },
                          onDelete: () async {
                            await _service.deleteImage(item.id);
                            _changed = true;
                            await _load();
                          },
                        )
                      else
                        const Text('Sliku možete dodati nakon što sačuvate novost.'),
                    ],
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