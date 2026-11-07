import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';


import '../../widgets/entity_form_dialog.dart';
import '../../widgets/paged_table.dart';
import '../../widgets/simple_crud_table.dart';

class LookupTable extends StatelessWidget {
  const LookupTable({
    super.key,
    required this.resource,
    required this.singular,
    required this.usageHint,
    this.hasDescription = true,
  });

  final String resource;
  final String singular;
  final String usageHint;
  final bool hasDescription;

  @override
  Widget build(BuildContext context) {
    final service = LookupService(context.read<ApiClient>(), resource);

    Future<bool> open([LookupItem? item]) async {
      final saved = await showDialog<bool>(
        context: context,
        builder: (_) => _LookupDialog(
          service: service,
          singular: singular,
          usageHint: usageHint,
          hasDescription: hasDescription,
          item: item,
        ),
      );
      return saved == true;
    }

    return SimpleCrudTable<LookupItem>(
      searchHint: 'Pretraga po nazivu',
      addLabel: 'Dodaj',
      load: (search, page, pageSize) => service.getPage(name: search, page: page, pageSize: pageSize),
      onAdd: () => open(),
      onEdit: (item) => open(item),
      columns: [
        PagedColumn(header: 'Naziv', flex: 3, cell: (item) => Text(item.name)),
        if (hasDescription)
          PagedColumn(
            header: 'Opis',
            flex: 6,
            cell: (item) => Text(item.description ?? '—', overflow: TextOverflow.ellipsis),
          ),
      ],
    );
  }
}

class _LookupDialog extends StatefulWidget {
  const _LookupDialog({
    required this.service,
    required this.singular,
    required this.usageHint,
    required this.hasDescription,
    this.item,
  });

  final LookupService service;
  final String singular;
  final String usageHint;
  final bool hasDescription;
  final LookupItem? item;

  @override
  State<_LookupDialog> createState() => _LookupDialogState();
}

class _LookupDialogState extends State<_LookupDialog> {
  late final _name = TextEditingController(text: widget.item?.name);
  late final _description = TextEditingController(text: widget.item?.description);

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return EntityFormDialog(
      title: item == null ? 'Novo: ${widget.singular}' : widget.singular,
      fieldsBuilder: (serverError) => [
        TextFormField(
          controller: _name,
          autofocus: true,
          maxLength: 100,
          decoration: InputDecoration(labelText: 'Naziv *', border: const OutlineInputBorder(), errorText: serverError('name')),
          validator: (value) => validateLength(value, 2, 100, 'Naziv mora imati između 2 i 100 znakova.'),
        ),
        if (widget.hasDescription) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: _description,
            maxLines: 3,
            maxLength: 300,
            decoration: InputDecoration(
              labelText: 'Opis',
              border: const OutlineInputBorder(),
              errorText: serverError('description'),
            ),
          ),
        ],
      ],
      onSave: () async {
        final name = _name.text.trim();
        final description = _description.text.trim().isEmpty ? null : _description.text.trim();

        if (item == null) {
          await widget.service.insert(name: name, description: description);
        } else {
          await widget.service.update(item.id, name: name, description: description);
        }
      },
      onDelete: item == null ? null : () => widget.service.delete(item.id),
      deleteMessage: item == null
          ? null
          : 'Obrisati "${item.name}"?\n\nAko se koristi (${widget.usageHint}), brisanje nije moguće.',
    );
  }
}