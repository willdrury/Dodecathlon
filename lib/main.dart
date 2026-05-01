import 'package:dodecathlon/providers/competition_provider.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/main_screen.dart';
import 'package:dodecathlon/utilities/custom_color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dodecathlon/providers/settings_provider.dart';
import 'package:dodecathlon/screens/auth_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dodecathlon/utilities/color_utility.dart';

import 'firebase_options.dart';
import 'models/competition.dart';
import 'models/event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Root of the application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStream = ref.watch(userProvider);
    final settings = ref.watch(settingsProvider);
    var brightness = MediaQuery.platformBrightnessOf(context);
    bool lightMode = brightness == Brightness.light;
    if (settings.isNotEmpty && settings['theme'] != null && settings['theme'] != 'system') {
      lightMode = settings['theme'] == 'light';
    }

    AsyncValue<List<Event>> eventStream = ref.watch(eventProvider);
    AsyncValue<List<Competition>> competitionStream = ref.watch(competitionProvider);

    Competition? currentCompetition = competitionStream.hasValue
      ? competitionStream.value!.where((c) => c.id == settings['current_competition']).firstOrNull
      : null;
    List<Event>? competitionEvents = [];

    if (currentCompetition != null && eventStream.hasValue) {
      competitionEvents = eventStream.value!.where((e) =>
          currentCompetition.events.contains(e.id)
      ).toList();
    }

    DateTime now = DateTime.now();
    Event? currentEvent = competitionEvents.isEmpty
        ? null
        : competitionEvents.where((e) =>
            e.startDate.isBefore(now) & e.endDate.isAfter(now)
         ).firstOrNull;

    final kColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.pinkAccent,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant
    ).copyWith(
      surface: Colors.white,
      surfaceDim: Color.lerp(Colors.white, Colors.black, .03),
      primaryContainer: Colors.white,
      secondaryContainer: Color.lerp(Colors.pinkAccent, Colors.white, .8),
      tertiaryContainer: Color.lerp(Colors.pinkAccent, Colors.white, .9),
      outline: Colors.black12
    );

    final kColorSchemeDark = ColorScheme.fromSeed(
      seedColor: Colors.pinkAccent,
      brightness: Brightness.dark
    ).copyWith(
      surface: Color.lerp(Colors.white, Colors.black, .9),
      surfaceDim: Color.lerp(Colors.black, Colors.pinkAccent, .1),
      outline: Colors.black38,
      primaryContainer: Color.lerp(Colors.white, Colors.black, .8),
      secondaryContainer: Color.lerp(Colors.black, Colors.pinkAccent, .8),
      tertiaryContainer: Color.lerp(Colors.black, Colors.pinkAccent, .5),
    );

    final kTextTheme = TextTheme(
      labelSmall: TextStyle(fontSize: 10, color: Colors.grey),
      labelMedium: TextStyle(color: Colors.grey),
    );

    // final kColorScheme = ColorScheme.fromSeed(
    //   seedColor: currentEvent == null ? Color(0xFF6A4C93) : currentEvent.themeColor,
    //   dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot
    // ).copyWith(surface: Colors.white);
    //
    // final kColorSchemeDark = ColorScheme.fromSeed(
    //   seedColor: currentEvent == null ? Color(0xFF6A4C93) : currentEvent.themeColor,
    //   brightness: Brightness.dark
    // );

    return MaterialApp(
      title: 'Athlon',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: kColorScheme,
        textTheme: kTextTheme,
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
            if (snapshot.hasData) { // User is logged in
              return userStream.when(
                data: (user) => user != null ? const MainScreen() : const AuthScreen(),
                loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
                error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
              );
            }
            return const AuthScreen();
          }
      ),
    );
  }
}