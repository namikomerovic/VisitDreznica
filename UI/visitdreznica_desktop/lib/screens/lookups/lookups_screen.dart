import 'package:flutter/material.dart';

import 'cities_table.dart';
import 'guides_table.dart';
import 'lookup_table.dart';

class LookupsScreen extends StatelessWidget {
  const LookupsScreen({super.key});

  static const _tabs = [
    'Tipovi soba',
    'Sadržaji soba',
    'Tipovi opreme',
    'Kategorije aktivnosti',
    'Tipovi mjesta',
    'Vodiči',
    'Države',
    'Gradovi',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [for (final tab in _tabs) Tab(text: tab)],
              ),
              const Divider(height: 1),
              const Expanded(
                child: TabBarView(
                  children: [
                    LookupTable(resource: 'RoomTypes', singular: 'Tip sobe', usageHint: 'sobe ovog tipa'),
                    LookupTable(resource: 'Amenities', singular: 'Sadržaj sobe', usageHint: 'sobe s ovim sadržajem'),
                    LookupTable(resource: 'EquipmentTypes', singular: 'Tip opreme', usageHint: 'oprema ovog tipa'),
                    LookupTable(
                      resource: 'ActivityCategories',
                      singular: 'Kategorija aktivnosti',
                      usageHint: 'aktivnosti u ovoj kategoriji',
                    ),
                    LookupTable(resource: 'PlaceTypes', singular: 'Tip mjesta', usageHint: 'mjesta ovog tipa'),
                    GuidesTable(),
                    LookupTable(
                      resource: 'Countries',
                      singular: 'Država',
                      usageHint: 'gradovi u ovoj državi',
                      hasDescription: false,
                    ),
                    CitiesTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}