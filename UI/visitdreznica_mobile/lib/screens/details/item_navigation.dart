import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

Future<void> openItemDetails(BuildContext context, ItemType type, int id) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Detalji (${type.label.toLowerCase()} #$id) dolaze u sljedećem koraku.')),
  );
}