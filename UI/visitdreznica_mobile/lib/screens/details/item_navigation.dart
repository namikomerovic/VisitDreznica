import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'item_details_screen.dart';

Future<void> openItemDetails(BuildContext context, ItemType type, int id) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ItemDetailsScreen(type: type, id: id)),
    );

void startReservation(BuildContext context, ItemType type, int id) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Rezervacija i plaćanje dolaze u sljedećem koraku.')),
  );
}