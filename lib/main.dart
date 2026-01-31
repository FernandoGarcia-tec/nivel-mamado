
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nivel_mamado/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // We'll configure this later
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6366f1); // Neon Indigo
    const Color secondaryColor = Color(0xFFa855f7); // Glowing Purple
    const Color backgroundColor = Color(0xFF000000); // Pure Black

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
      labelLarge: GoogleFonts.robotoMono(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    );

    return MaterialApp(
      title: 'Nivel: Mamado',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: Colors.black,
          onSurface: Colors.white,
          background: backgroundColor,
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        textTheme: appTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.grey[900]?.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[800]!, width: 1),
          ),
          elevation: 8,
          shadowColor: secondaryColor.withOpacity(0.2),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
