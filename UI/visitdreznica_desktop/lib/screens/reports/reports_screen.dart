import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/dialogs.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  static const _maxDays = 366;

  late final ReportService _service;
  late DateTimeRange _range;
  ReportKind? _downloading;

  @override
  void initState() {
    super.initState();
    _service = ReportService(context.read<ApiClient>());

    final now = DateTime.now();
    _range = DateTimeRange(start: DateTime(now.year, now.month - 11, 1), end: DateTime(now.year, now.month, now.day));
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: _range,
      helpText: 'Period izvještaja',
    );

    if (picked == null || !mounted) return;

    if (picked.duration.inDays + 1 > _maxDays) {
      showMessage(context, 'Period izvještaja može biti najviše godinu dana.', isError: true);
      return;
    }

    setState(() => _range = picked);
  }

  Future<void> _download(ReportKind kind) async {
    setState(() => _downloading = kind);

    try {
      final bytes = await _service.downloadPdf(kind, _range.start, _range.end);
      final fileName = '${kind.filePrefix}_${_fileDate(_range.start)}_${_fileDate(_range.end)}.pdf';

      final target = await FilePicker.saveFile(
        dialogTitle: 'Sačuvaj izvještaj',
        fileName: fileName,
        bytes: bytes,
      );

      if (target == null || !mounted) return;

      final file = File(target.toFilePath());

      if (!await file.exists() || await file.length() == 0) {
        await file.writeAsBytes(bytes, flush: true);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Izvještaj je sačuvan: ${file.path}'),
          action: SnackBarAction(label: 'Otvori', onPressed: () => Process.run('explorer', [file.path])),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _downloading = null);
    }
  }

  static String _fileDate(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.date_range),
                const SizedBox(width: 12),
                Text('Period:', style: theme.textTheme.titleMedium),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _pickRange,
                  child: Text('${Formatters.date(_range.start)} – ${Formatters.date(_range.end)}'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Najviše godinu dana. Isti period se koristi za sva tri izvještaja.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _ReportCard(
              icon: Icons.payments_outlined,
              title: 'Finansijski izvještaj',
              description: 'Uplate, povrati i neto prihod po vrsti (smještaj, oprema, aktivnosti) i po mjesecima.',
              loading: _downloading == ReportKind.financial,
              enabled: _downloading == null,
              onDownload: () => _download(ReportKind.financial),
            ),
            _ReportCard(
              icon: Icons.bed_outlined,
              title: 'Zauzetost smještaja',
              description: 'Po sobi: zauzete od mogućih noći, popunjenost u %, broj rezervacija, prosječan boravak i prihod.',
              loading: _downloading == ReportKind.occupancy,
              enabled: _downloading == null,
              onDownload: () => _download(ReportKind.occupancy),
            ),
            _ReportCard(
              icon: Icons.hiking_outlined,
              title: 'Aktivnosti i ocjene',
              description: 'Termini, popunjenost i prihod po aktivnosti, te ocjene, favoriti i pregledi mjesta.',
              loading: _downloading == ReportKind.activities,
              enabled: _downloading == null,
              onDownload: () => _download(ReportKind.activities),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.loading,
    required this.enabled,
    required this.onDownload,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool loading;
  final bool enabled;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 340,
      height: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Expanded(child: Text(description, style: theme.textTheme.bodySmall)),
              FilledButton.icon(
                onPressed: enabled ? onDownload : null,
                icon: loading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Preuzmi PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}