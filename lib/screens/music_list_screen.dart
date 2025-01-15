import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/music.dart';
import '../services/api_service.dart';
import '../providers/favorite_provider.dart';
import 'music_detail_screen.dart';

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({super.key});

  @override
  _MusicListScreenState createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  late Future<List<Music>> _musicList;

 @override
  void initState() {
    super.initState();
    _musicList = ApiService().fetchMusic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteProvider>(context, listen: false).loadFavorites();
    });
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Music Gallery'),
          bottom: TabBar(
            indicatorColor: Colors.white, // Warna garis indikator tab
            labelColor: Colors.white, // Warna teks tab saat dipilih
            unselectedLabelColor: Colors.grey[400], // Warna teks tab yang tidak dipilih
            labelStyle: const TextStyle( // Gaya teks tab saat dipilih
              fontSize: 20, // Ukuran teks untuk tab yang dipilih
              fontWeight: FontWeight.bold, // Contoh tambahan: teks tebal
            ),
            unselectedLabelStyle: const TextStyle( // Gaya teks tab yang tidak dipilih
              fontSize: 15, // Ukuran teks untuk tab yang tidak dipilih
            ),
            tabs: const [
              Tab(text: 'All Music'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMusicList(),
            _buildFavoritesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicList() {
    return FutureBuilder<List<Music>>(
      future: _musicList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No music available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final music = snapshot.data![index];
            return _buildMusicItem(music);
          },
        );
      },
    );
  }

  Widget _buildFavoritesList() {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final favorites = favoriteProvider.favorites;
        if (favorites.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return _buildMusicItem(favorites[index]);
          },
        );
      },
    );
  }

  Widget _buildMusicItem(Music music) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final isFavorite = favoriteProvider.isFavorite(music.id);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 2),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                music.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note),
                  );
                },
              ),
            ),
            title: Text(
              toTitleCase(music.name), // Format judul menjadi capital each word
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              '${toTitleCase(music.artistName)} - ${toTitleCase(music.genre)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                  ),
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () => favoriteProvider.toggleFavorite(music),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicDetailScreen(music: music),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
