import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.text, this.isError = false});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = isError ? scheme.errorContainer : scheme.secondaryContainer;
    final foreground = isError ? scheme.onErrorContainer : scheme.onSecondaryContainer;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.info_outline, color: foreground),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: foreground))),
        ],
      ),
    );
  }
}