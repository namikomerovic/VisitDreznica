import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  const EmailField({
    super.key,
    required this.controller,
    required this.decoration,
    this.validator,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final InputDecoration decoration;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final TextInputAction textInputAction;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  static const _domains = ['gmail.com', 'hotmail.com', 'outlook.com', 'yahoo.com', 'icloud.com'];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  void _complete(String domain) {
    final text = widget.controller.text.trim();
    final at = text.indexOf('@');
    final local = at >= 0 ? text.substring(0, at) : text;
    final value = '$local@$domain';

    widget.controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  List<String> _suggestions() {
    final text = widget.controller.text.trim();
    if (text.isEmpty) return const [];

    final at = text.indexOf('@');
    if (at < 0) return _domains;
    if (at == 0) return const [];

    final typed = text.substring(at + 1).toLowerCase();
    return _domains.where((d) => d.startsWith(typed) && d != typed).toList();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = widget.enabled ? _suggestions() : const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: widget.textInputAction,
          decoration: widget.decoration,
          validator: widget.validator,
        ),
        if (suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final domain in suggestions)
                  ActionChip(
                    label: Text('@$domain'),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _complete(domain),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}