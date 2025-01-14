import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/music.dart';
import '../providers/favorite_provider.dart';

class MusicDetailScreen extends StatelessWidget {
  final Music music;

  const MusicDetailScreen({
    Key? key,
    required this.music,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(music.name),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final isFavorite = favoriteProvider.isFavorite(music.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => favoriteProvider.toggleFavorite(music),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  music.image,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note, size: 64),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Artist',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(music.artistName),
            const SizedBox(height: 16),
            Text(
              'Genre',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(music.genre),
            const SizedBox(height: 16),
            Text(
              'Year',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(music.year),
          ],
        ),
      ),
    );
  }
}