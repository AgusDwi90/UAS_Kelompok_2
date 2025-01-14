class Music {
  final String id;
  final String name;
  final String artistName;
  final String year;
  final String image;
  final String genre;
  bool isFavorite;

  Music({
    required this.id,
    required this.name,
    required this.artistName,
    required this.year,
    required this.image,
    required this.genre,
    this.isFavorite = false,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    final List<dynamic> artists = json['artist'] ?? [];
    final List<dynamic> genres = json['genre'] ?? [];
    
    return Music(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      artistName: artists.isNotEmpty ? artists[0]['name'] ?? '' : '',
      year: json['year']?.toString() ?? '',
      image: json['image'] ?? '',
      genre: genres.isNotEmpty ? genres[0]['name'] ?? '' : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artistName': artistName,
      'year': year,
      'image': image,
      'genre': genre,
    };
  }
}