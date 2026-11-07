import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/form_helpers.dart';
import '../../widgets/entity_form_dialog.dart';
import '../../widgets/paged_table.dart';
import '../../widgets/simple_crud_table.dart';

class CitiesTable extends StatelessWidget {
  const CitiesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiClient>();
    final service = CityService(api);
    final countries = LookupService(api, 'Countries');

    Future<bool> open([City? city]) async {
      final list = await countries.getAll();
      if (!context.mounted) return false;

      return await showDialog<bool>(
            context: context,
            builder: (_) => _CityDialog(service: service, countries: list, city: city),
          ) ==
          true;
    }

    return SimpleCrudTable<City>(
      searchHint: 'Naziv grada',
      addLabel: 'Dodaj grad',
      load: (search, page, pageSize) => service.getPage(name: search, page: page, pageSize: pageSize),
      onAdd: () => open(),
      onEdit: (city) => open(city),
      columns: [
        PagedColumn(header: 'Grad', flex: 3, cell: (city) => Text(city.name)),
        PagedColumn(header: 'Poštanski broj', flex: 2, cell: (city) => Text(city.postalCode ?? '—')),
        PagedColumn(header: 'Država', flex: 3, cell: (city) => Text(city.countryName)),
      ],
    );
  }
}

class _CityDialog extends StatefulWidget {
  const _CityDialog({required this.service, required this.countries, this.city});

  final CityService service;
  final List<LookupItem> countries;
  final City? city;

  @override
  State<_CityDialog> createState() => _CityDialogState();
}

class _CityDialogState extends State<_CityDialog> {
  late final _name = TextEditingController(text: widget.city?.name);
  late final _postalCode = TextEditingController(text: widget.city?.postalCode);
  late int? _countryId = widget.city?.countryId;

  @override
  void dispose() {
    _name.dispose();
    _postalCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final city = widget.city;

    return EntityFormDialog(
      title: city == null ? 'Novi grad' : 'Grad',
      fieldsBuilder: (serverError) => [
        TextFormField(
          controller: _name,
          autofocus: true,
          maxLength: 100,
          decoration: InputDecoration(labelText: 'Naziv *', border: const OutlineInputBorder(), errorText: serverError('name')),
          validator: (value) => validateLength(value, 2, 100, 'Naziv mora imati između 2 i 100 znakova.'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _postalCode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
          decoration: InputDecoration(
            labelText: 'Poštanski broj',
            hintText: 'npr. 88000',
            border: const OutlineInputBorder(),
            errorText: serverError('postalCode'),
          ),
          validator: (value) {
            final length = value?.trim().length ?? 0;
            return length == 0 || (length >= 4 && length <= 6) ? null : 'Poštanski broj ima 4 do 6 cifara.';
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: _countryId,
          decoration: InputDecoration(labelText: 'Država *', border: const OutlineInputBorder(), errorText: serverError('countryId')),
          items: [for (final country in widget.countries) DropdownMenuItem(value: country.id, child: Text(country.name))],
          onChanged: (value) => _countryId = value,
          validator: (value) => value == null ? 'Odaberite državu.' : null,
        ),
      ],
      onSave: () async {
        final postalCode = _postalCode.text.trim().isEmpty ? null : _postalCode.text.trim();

        if (city == null) {
          await widget.service.insert(name: _name.text.trim(), postalCode: postalCode, countryId: _countryId!);
        } else {
          await widget.service.update(city.id, name: _name.text.trim(), postalCode: postalCode, countryId: _countryId!);
        }
      },
      onDelete: city == null ? null : () => widget.service.delete(city.id),
      deleteMessage: city == null ? null : 'Obrisati grad ${city.name}?\n\nAko ga koriste korisnici, brisanje nije moguće.',
    );
  }
}