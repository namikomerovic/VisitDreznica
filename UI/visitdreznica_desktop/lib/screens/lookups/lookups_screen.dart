import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'cities_table.dart';
import 'guides_table.dart';
import 'lookup_table.dart';

class LookupsScreen extends StatelessWidget {
  const LookupsScreen({super.key});

  List<String> get _tabs => [
        tr.tabRoomTypes,
        tr.tabRoomAmenities,
        tr.tabEquipmentTypes,
        tr.tabActivityCategories,
        tr.tabPlaceTypes,
        tr.tabGuides,
        tr.tabCountries,
        tr.tabCities,
      ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 900 ? 12 : 24),
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
              Expanded(
                child: TabBarView(
                  children: [
                    LookupTable(resource: 'RoomTypes', singular: tr.roomType, usageHint: tr.roomTypeUsage),
                    LookupTable(resource: 'Amenities', singular: tr.roomAmenity, usageHint: tr.roomAmenityUsage),
                    LookupTable(resource: 'EquipmentTypes', singular: tr.equipmentType, usageHint: tr.equipmentTypeUsage),
                    LookupTable(
                      resource: 'ActivityCategories',
                      singular: tr.activityCategory,
                      usageHint: tr.activityCategoryUsage,
                    ),
                    LookupTable(resource: 'PlaceTypes', singular: tr.placeType, usageHint: tr.placeTypeUsage),
                    const GuidesTable(),
                    LookupTable(
                      resource: 'Countries',
                      singular: tr.country,
                      usageHint: tr.countryUsage,
                      hasDescription: false,
                    ),
                    const CitiesTable(),
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