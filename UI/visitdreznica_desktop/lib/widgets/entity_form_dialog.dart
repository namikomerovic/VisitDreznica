import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../utils/form_helpers.dart';
import 'dialogs.dart';

typedef ServerErrorLookup = String? Function(String field);

class EntityFormDialog extends StatefulWidget {
  const EntityFormDialog({
    super.key,
    required this.title,
    required this.fieldsBuilder,
    required this.onSave,
    this.onDelete,
    this.deleteMessage,
    this.width = 440,
  });

  final String title;
  final List<Widget> Function(ServerErrorLookup serverError) fieldsBuilder;
  final Future<void> Function() onSave;
  final Future<void> Function()? onDelete;
  final String? deleteMessage;
  final double width;

  @override
  State<EntityFormDialog> createState() => _EntityFormDialogState();
}

class _EntityFormDialogState extends State<EntityFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;
  Map<String, String> _serverErrors = {};

  Future<void> _save() async {
    setState(() {
      _error = null;
      _serverErrors = {};
    });

    if (!_formKey.currentState!.validate()) return;

    await _run(widget.onSave);
  }

  Future<void> _delete() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Brisanje',
      message: widget.deleteMessage ?? 'Obrisati ovaj zapis?',
      confirmLabel: 'Obriši',
      destructive: true,
    );

    if (confirmed) {
      await _run(widget.onDelete!);
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);

    try {
      await action();
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;

      setState(() {
        if (e.fieldErrors.isNotEmpty) {
          _serverErrors = normalizeServerErrors(e.fieldErrors);
        } else {
          _error = e.message;
        }
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: widget.width,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...widget.fieldsBuilder((field) => _serverErrors[field.toLowerCase()]),
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: scheme.errorContainer, borderRadius: BorderRadius.circular(8)),
                  child: Text(_error!, style: TextStyle(color: scheme.onErrorContainer)),
                ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: _busy ? null : _delete,
            child: Text('Obriši', style: TextStyle(color: scheme.error)),
          ),
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context, false), child: const Text('Odustani')),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: _busy
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Sačuvaj'),
        ),
      ],
    );
  }
}