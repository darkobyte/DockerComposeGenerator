import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'models/app_settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppSettings(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    
    return MaterialApp(
      title: 'Docker Compose Creator',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.lightBlue[300]!,
          secondary: Colors.lightBlue[200]!,
          background: const Color(0xFF121212),
          surface: const Color(0xFF1E1E1E),
          onSurface: Colors.white70,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: const Color(0xFF2D2D2D),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        // ...dark theme settings...
      ),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
