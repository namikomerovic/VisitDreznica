import 'package:flutter/material.dart';

/// Traka s filterima iznad tabele. Djeca se pišu kao za [Row]:
/// filteri, pa `Spacer()`, pa akcije (npr. dugme "Dodaj").
/// Kad nema mjesta, filteri prelaze u novi red umjesto da se preliju.
class FilterBar extends StatelessWidget {
  const FilterBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacer = children.indexWhere((x) => x is Spacer);
    final filters = spacer < 0 ? children : children.sublist(0, spacer);
    final actions = spacer < 0 ? const <Widget>[] : children.sublist(spacer + 1);

    bool isGap(Widget x) => x is SizedBox && x.child == null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [for (final x in filters) if (!isGap(x)) x],
          ),
        ),
        for (final x in actions) ...[const SizedBox(width: 12), if (!isGap(x)) x],
      ],
    );
  }
}
