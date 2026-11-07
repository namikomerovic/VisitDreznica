import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key, required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = NewsService(context.read<ApiClient>());

    return Scaffold(
      appBar: AppBar(title: const Text('Novost')),
      body: ListView(
        children: [
          if (item.hasImage) AspectRatio(aspectRatio: 16 / 9, child: AuthImage(url: service.imageUrl(item.id))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(Formatters.date(item.publishedAt), style: theme.textTheme.bodySmall),
                const SizedBox(height: 16),
                Text(item.content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}