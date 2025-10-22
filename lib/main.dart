import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/main_screen.dart';
import 'package:dodecathlon/utilities/custom_color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dodecathlon/providers/settings_provider.dart';
import 'package:dodecathlon/screens/auth_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dodecathlon/utilities/color_utility.dart';

import 'firebase_options.dart';

// final kColorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF00A87F)).copyWith(
//   surface: Colors.white,
//   primary: Color(0xFF00A87F),
//   secondary: Color(0xFF00DEA8),
//   tertiary: Color(0xFF00533F),
// );
// final kColorScheme = ColorScheme.fromSeed(seedColor: Color(0xFFFFCA3A)).copyWith(
//   surface: Colors.white,
//   primary: Color(0xFFFFCA3A),
//   secondary: Color(0xFFFED871),
//   tertiary: Color(0xFFE6AD12),
// );
final kColorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF6A4C93)).copyWith(
  surface: Colors.white,
  primary: Color(0xFF6A4C93),
  secondary: Color(0xFFA580D7),
  tertiary: Color(0xFF4D3370),
);
final kColorSchemeDark = ColorScheme.fromSeed(seedColor: Color(0xFF6A4C93), brightness: Brightness.dark);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    var brightness = MediaQuery.platformBrightnessOf(context);
    bool lightMode = brightness == Brightness.light;
    if (settings.isNotEmpty && settings['theme'] != null && settings['theme'] != 'system') {
      lightMode = settings['theme'] == 'light';
    }

    return MaterialApp(
      title: 'You Better',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: kColorScheme,
        extensions: <ThemeExtension<dynamic>>[
          CustomColorsExtension(
            primaryDim: ColorUtility().lighten(kColorScheme.primary, .5),
          ),
        ]
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: kColorSchemeDark,
      ),
      themeMode: lightMode ? ThemeMode.light : ThemeMode.dark,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              ref.read(userProvider);
              return MainScreen();
            }
            return const AuthScreen();
          }
      ),
    );
  }
}