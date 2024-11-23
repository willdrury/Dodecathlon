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

final kColorScheme = ColorScheme.fromSeed(seedColor: Colors.red).copyWith(
  surface: Colors.white,
);
final kColorSchemeDark = ColorScheme.fromSeed(seedColor: Colors.pink, brightness: Brightness.dark);

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

    return MaterialApp(
      title: 'You Better',
      theme: ThemeData(
        // colorScheme: settings[Setting.darkModeEnabled]! ? kColorSchemeDark : kColorScheme,
        colorScheme: kColorScheme,
        extensions: <ThemeExtension<dynamic>>[
          CustomColorsExtension(
            primaryDim: ColorUtility().lighten(kColorScheme.primary, .5),
          ),
        ]
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return MainScreen();
            }
            return const AuthScreen();
          }
      ),
    );
  }
}