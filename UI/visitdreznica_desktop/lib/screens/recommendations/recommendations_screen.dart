import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/dialogs.dart';
import '../../widgets/error_view.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late final RecommendationService _service;
  RecommenderModelInfo? _info;
  String? _error;
  bool _training = false;

  @override
  void initState() {
    super.initState();
    _service = RecommendationService(context.read<ApiClient>());
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);

    try {
      final info = await _service.getModel();
      if (mounted) setState(() => _info = info);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _train() async {
    setState(() => _training = true);

    try {
      final info = await _service.train();
      if (!mounted) return;
      setState(() => _info = info);
      showMessage(context, info.isModelTrained ? 'Model je ponovo istreniran.' : 'Premalo podataka za treniranje modela.');
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _training = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final info = _info;
    if (info == null) return const Center(child: CircularProgressIndicator());

    final theme = Theme.of(context);
    final k = info.topK ?? 3;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  info.isModelTrained ? Icons.check_circle : Icons.info_outline,
                  size: 32,
                  color: info.isModelTrained ? const Color(0xFF16A34A) : theme.colorScheme.tertiary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.isModelTrained ? 'Model je istreniran i koristi se za preporuke' : 'Model nije istreniran',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        info.note ??
                            'Zadnje treniranje: ${info.trainedAt == null ? '—' : Formatters.dateTime(info.trainedAt!)}. '
                                'Model se automatski ponovo trenira svakih 6 sati.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: _training ? null : _train,
                  icon: _training
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.model_training),
                  label: const Text('Ponovo treniraj'),
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
            _Stat(label: 'Interakcija', value: '${info.interactionCount}'),
            _Stat(label: 'Izbora (pozitivnih)', value: '${info.positiveCount}'),
            _Stat(label: 'Gostiju', value: '${info.userCount}'),
            _Stat(label: 'Stavki', value: '${info.itemCount}'),
          ],
        ),
        if (info.isModelTrained) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kvalitet preporuka (HitRate@$k)', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Koliko često je stvarno izabrana (sakrivena) stavka među top $k preporuka. '
                    'Evaluirano na ${info.evaluatedCount} izbora · ${info.evaluationMethod ?? ''}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  _MetricBar(label: 'Naš model (Matrix Factorization)', value: info.hitRate ?? 0, highlight: true),
                  _MetricBar(label: 'Popularnost (svima isto)', value: info.popularityHitRate ?? 0),
                  _MetricBar(label: 'Slučajan izbor', value: info.randomHitRate ?? 0),
                  const SizedBox(height: 12),
                  Text(
                    'Izabrani parametri: rank ${info.selectedRank}, λ ${info.selectedLambda}, α ${info.selectedAlpha}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Preporuke koriste one-class Matrix Factorization (ML.NET) nad interakcijama gostiju: '
              'recenzijama, favoritima, rezervacijama i pregledima. Gosti bez dovoljno interakcija dobijaju '
              'popularne stavke. Detalji su u dokumentu recommender-dokumentacija.md.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              const SizedBox(height: 6),
              Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricBar extends StatelessWidget {
  const _MetricBar({required this.label, required this.value, this.highlight = false});

  final String label;
  final double value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 280,
            child: Text(label, style: TextStyle(fontWeight: highlight ? FontWeight.w600 : FontWeight.normal)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value.clamp(0, 1),
                minHeight: 14,
                color: highlight ? scheme.primary : scheme.outline,
                backgroundColor: scheme.surfaceContainerHighest,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Text('${Formatters.decimal(value * 100)} %', textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}