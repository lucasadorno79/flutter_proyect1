import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/preferences_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final value = await PreferencesService.loadDarkMode();
    setState(() {
      isDarkMode = value;
    });
  }

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    PreferencesService.saveDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🌍 LOCALIZACIÓN (ACÁ ESTÁ LA CLAVE)
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🌓 TEMA
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // 🏠 HOME
      home: FutureBuilder<bool>(
  future: AuthService.isLoggedIn(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    return snapshot.data!
        ? HomeScreen(
            isDarkMode: isDarkMode,
            onThemeChanged: toggleTheme,
          )
        : const LoginScreen();
  },
),
      routes: {
        '/home': (context) => HomeScreen(
              isDarkMode: isDarkMode,
              onThemeChanged: toggleTheme,
            ),
      },
    );
  }
}
