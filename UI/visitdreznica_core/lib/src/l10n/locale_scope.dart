import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'locale_controller.dart';

/// Kad se promijeni jezik, ponovo iscrta sve ekrane (i otvorene dijaloge),
/// a da se ne izgubi stanje – npr. otvoreni tab ili unos u formi.
class LocaleScope extends StatefulWidget {
  const LocaleScope({super.key, required this.child});

  final Widget child;

  @override
  State<LocaleScope> createState() => _LocaleScopeState();
}

class _LocaleScopeState extends State<LocaleScope> {
  late final LocaleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<LocaleController>()..addListener(_rebuildAll);
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuildAll);
    super.dispose();
  }

  void _rebuildAll() {
    void mark(Element element) {
      element.markNeedsBuild();
      element.visitChildren(mark);
    }

    (context as Element).visitChildren(mark);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
