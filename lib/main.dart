import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/music_list_screen.dart';
import 'services/database_helper.dart';
import 'providers/favorite_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoriteProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MusicListScreen(),
    );
  }
}
