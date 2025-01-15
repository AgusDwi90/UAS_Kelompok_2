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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          primary: const Color(0xFF0D47A1), // Biru tua
          secondary: const Color(0xFF29B6F6), // Biru muda
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Roboto',
              bodyColor: Colors.black87,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          elevation: 4,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        useMaterial3: true,
      ),
      home: const MusicListScreen(),
    );
  }
}
