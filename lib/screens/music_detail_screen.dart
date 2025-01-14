import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/music.dart';
import '../providers/favorite_provider.dart';

class MusicDetailScreen extends StatelessWidget {
  final Music music;

  const MusicDetailScreen({
    super.key,
    required this.music,
  });

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          toTitleCase(music.name), // Format judul menjadi capital each word
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final isFavorite = favoriteProvider.isFavorite(music.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => favoriteProvider.toggleFavorite(music),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Music Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    music.image,
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 250,
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(Icons.music_note, size: 64),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Music Info
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        title: 'Artist',
                        value: toTitleCase(music.artistName), // Format menjadi title case
                        titleColor: Colors.blue[800]!,
                        valueColor: Colors.black87,
                        context: context,
                      ),
                      const Divider(),
                      _buildDetailRow(
                        title: 'Genre',
                        value: toTitleCase(music.genre), // Format menjadi title case
                        titleColor: Colors.blue[800]!,
                        valueColor: Colors.black87,
                        context: context,
                      ),
                      const Divider(),
                      _buildDetailRow(
                        title: 'Year',
                        value: music.year, // Tahun tidak diubah formatnya
                        titleColor: Colors.blue[800]!,
                        valueColor: Colors.black87,
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Play Button
              ElevatedButton.icon(
                onPressed: () {
                  // Play music functionality (if applicable)
                },
                icon: const Icon(Icons.play_arrow, size: 24),
                label: const Text('Play Now'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    required Color titleColor,
    required Color valueColor,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
