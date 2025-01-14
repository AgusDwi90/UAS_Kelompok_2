import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/music.dart';
import '../services/api_service.dart';
import '../providers/favorite_provider.dart';
import 'music_detail_screen.dart';

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({Key? key}) : super(key: key);

  @override
  _MusicListScreenState createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  late Future<List<Music>> _musicList;

  @override
  void initState() {
    super.initState();
    _musicList = ApiService().fetchMusic();
    Provider.of<FavoriteProvider>(context, listen: false).loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Music App'),
          bottom: const TabBar(
            tabs: [
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
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
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
        title: Text(music.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(music.artistName),
            Text('${music.genre} - ${music.year}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
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