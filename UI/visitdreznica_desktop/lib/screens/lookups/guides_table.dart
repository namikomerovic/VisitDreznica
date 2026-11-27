import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';


import '../../widgets/entity_form_dialog.dart';
import '../../widgets/paged_table.dart';
import '../../widgets/simple_crud_table.dart';

final _phonePattern = RegExp(r'^\+?[0-9 ]{6,20}$');

class GuidesTable extends StatelessWidget {
  const GuidesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final service = GuideService(context.read<ApiClient>());

    Future<bool> open([Guide? guide]) async =>
        await showDialog<bool>(context: context, builder: (_) => _GuideDialog(service: service, guide: guide)) == true;

    return SimpleCrudTable<Guide>(
      searchHint: tr.firstOrLastName,
      addLabel: tr.addGuide,
      load: (search, page, pageSize) => service.getPage(name: search, page: page, pageSize: pageSize),
      onAdd: () => open(),
      onEdit: (guide) => open(guide),
      columns: [
        PagedColumn(header: tr.fullName, flex: 3, cell: (guide) => Text(guide.fullName)),
        PagedColumn(header: tr.phone, flex: 3, cell: (guide) => Text(guide.phoneNumber ?? '—')),
      ],
    );
  }
}

class _GuideDialog extends StatefulWidget {
  const _GuideDialog({required this.service, this.guide});

  final GuideService service;
  final Guide? guide;

  @override
  State<_GuideDialog> createState() => _GuideDialogState();
}

class _GuideDialogState extends State<_GuideDialog> {
  late final _firstName = TextEditingController(text: widget.guide?.firstName);
  late final _lastName = TextEditingController(text: widget.guide?.lastName);
  late final _phone = TextEditingController(text: widget.guide?.phoneNumber);

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guide = widget.guide;

    return EntityFormDialog(
      title: guide == null ? tr.newGuide : tr.guide,
      fieldsBuilder: (serverError) => [
        TextFormField(
          controller: _firstName,
          autofocus: true,
          maxLength: 50,
          decoration: InputDecoration(labelText: tr.firstNameRequiredShort, border: const OutlineInputBorder(), errorText: serverError('firstName')),
          validator: (value) => validateLength(value, 1, 50, tr.enterFirstName),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _lastName,
          maxLength: 50,
          decoration: InputDecoration(labelText: tr.lastNameRequiredShort, border: const OutlineInputBorder(), errorText: serverError('lastName')),
          validator: (value) => validateLength(value, 1, 50, tr.enterLastName),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phone,
          decoration: InputDecoration(
            labelText: tr.phone,
            hintText: tr.phoneExample,
            border: const OutlineInputBorder(),
            errorText: serverError('phoneNumber'),
          ),
          validator: (value) {
            final trimmed = value?.trim() ?? '';
            return trimmed.isEmpty || _phonePattern.hasMatch(trimmed)
                ? null
                : tr.validationPhone;
          },
        ),
      ],
      onSave: () async {
        final phone = _phone.text.trim().isEmpty ? null : _phone.text.trim();

        if (guide == null) {
          await widget.service.insert(firstName: _firstName.text.trim(), lastName: _lastName.text.trim(), phoneNumber: phone);
        } else {
          await widget.service.update(guide.id,
              firstName: _firstName.text.trim(), lastName: _lastName.text.trim(), phoneNumber: phone);
        }
      },
      onDelete: guide == null ? null : () => widget.service.delete(guide.id),
      deleteMessage: guide == null
          ? null
          : tr.deleteGuideQuestion(guide.fullName),
    );
  }
}