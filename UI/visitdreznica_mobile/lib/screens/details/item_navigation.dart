import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../booking/activity_booking_screen.dart';
import '../booking/equipment_booking_screen.dart';
import '../booking/room_booking_screen.dart';
import 'item_details_screen.dart';

Future<void> openItemDetails(BuildContext context, ItemType type, int id) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ItemDetailsScreen(type: type, id: id)),
    );

Future<void> startReservation(BuildContext context, ItemType type, int id) {
  final Widget screen = switch (type) {
    ItemType.room => RoomBookingScreen(roomId: id),
    ItemType.equipment => EquipmentBookingScreen(equipmentId: id),
    ItemType.activity => ActivityBookingScreen(activityId: id),
    ItemType.place => throw ArgumentError('Mjesta se ne rezervišu.'),
  };

  return Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
}