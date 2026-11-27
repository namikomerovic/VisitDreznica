import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class CounterField extends StatelessWidget {
  const CounterField({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        IconButton.outlined(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(width: 44, child: Text('$value', textAlign: TextAlign.center, style: style)),
        IconButton.outlined(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class NoteField extends StatelessWidget {
  const NoteField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 2,
      maxLength: 500,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: tr.noteOptional,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class PriceRow {
  const PriceRow(this.label, this.value);

  final String label;
  final String value;
}

class PriceSummary extends StatelessWidget {
  const PriceSummary({super.key, required this.rows, required this.total});

  final List<PriceRow> rows;
  final String total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(child: Text(row.label)),
                    Text(row.value),
                  ],
                ),
              ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(child: Text(tr.total, style: theme.textTheme.titleMedium)),
                Text(
                  total,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookingBar extends StatelessWidget {
  const BookingBar({super.key, required this.total, required this.busy, required this.onPressed});

  final String? total;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            Expanded(
              child: total == null
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr.total, style: theme.textTheme.bodySmall),
                        Text(total!, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
            ),
            FilledButton.icon(
              onPressed: busy ? null : onPressed,
              style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
              icon: busy
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.lock_outline),
              label: Text(tr.reserveAndPay),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> confirmPayment(BuildContext context, String amount) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(tr.paymentConfirmation),
      content: Text(tr.continueToCardPayment(amount)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr.cancel)),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.lock_outline),
          label: Text(tr.pay),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
