import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/settings_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/providers/user_event_rankings_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/screens/loading_screen.dart';
import 'package:dodecathlon/screens/post_creation_screen.dart';
import 'package:dodecathlon/widgets/default_app_bar.dart';
import 'package:dodecathlon/widgets/default_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dodecathlon/screens/submission_selection_screen.dart';
import 'package:dodecathlon/screens/events_screen.dart';
import 'package:dodecathlon/screens/rankings_screen.dart';
import 'package:dodecathlon/screens/social_screen.dart';
import 'package:dodecathlon/screens/home_screen.dart';

import '../models/event.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends ConsumerState<MainScreen> with WidgetsBindingObserver {

  // Display variables
  late Widget _currentScreen = HomeScreen(onPageChange: onDestinationSelected,);
  int _currentPageIndex = 0;
  bool _showAppBar = true;
  bool _useAppBarShadow = false;
  bool _newEventStarted = false;
  bool _showNewEventStartedButton = false;
  Color? _appBarColor;
  String _appBarLabel = '';
  Color _appBarTextColor = Colors.black;
  Color _scaffoldBackgroundColor = Colors.white;
  Widget? _floatingActionButton;
  ScrollPhysics _scrollPhysics = NeverScrollableScrollPhysics();
  late ScrollController _scrollController;

  // Data variables
  Map<dynamic, dynamic>? _userSettings;
  List<Event>? _events;
  late User? currentUser;
  late AsyncValue<List<User>> users;
  Event? _currentEvent;
  List<(String, int)>? _userRankings;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        print("APP STATE RESUMED");
        setState(() {
          _refreshContent();
        });
        break;
      case AppLifecycleState.inactive:
        print("APP STATE INACTIVE");
        break;
      case AppLifecycleState.paused:
        print("APP STATE PAUSED");
        break;
      default:
        break;
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('A new event has begun'),
          content: Text(
            'Select a difficulty to get started!',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme
                    .of(context)
                    .textTheme
                    .labelLarge,
              ),
              child: const Text('Return Home'),
              onPressed: () {
                setState(() {
                  _currentPageIndex = 0;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _refreshContent() {
    if (currentUser == null || _events == null || _userSettings == null) {
      return;
    }
    if (_events!.isEmpty) {
      return;
    }
    if (_currentEvent == null) {
      return;
    }

    // Detect date chance since last login
    DateTime now = DateTime.now();
    DateTime lastLoginDate = _userSettings!['last_login_date'] as DateTime;
    if (lastLoginDate.day != now.day || lastLoginDate.month != now.month || lastLoginDate.year != now.year) {

      // Update user event rank
      if (_userRankings != null && _userRankings!.isNotEmpty) {
        List<String> userIdsByRank = _userRankings!.map((e) => e.$1).toList();
        int currentRank = userIdsByRank.indexOf(currentUser!.id!);
        if (currentRank > -1) {
          currentUser!.currentEventRank[0] = currentRank;
          currentUser!.update();
        }
      }
    }

    // Check if new event has started
    if (!currentUser!.currentEventIndexes.contains(_currentEvent!.id)) {

      // Navigate user to home page
      if (_currentPageIndex != 0) {
        _showNewEventStartedButton = true;
      }

      setState(() {
        _newEventStarted = true;
      });
    }
  }

  void onDestinationSelected(int index, BuildContext ctx) async {
    setState(() {
      switch (index) {
        case 0:
          _currentPageIndex = index;
          _currentScreen = HomeScreen(onPageChange: onDestinationSelected,);
          _showAppBar = true;
          _appBarLabel = '';
          _useAppBarShadow = false;
          _appBarColor = Colors.transparent;
          _appBarTextColor = Theme.of(context).colorScheme.onSurface;
          _scaffoldBackgroundColor = Theme.of(context).colorScheme.surface;
          _floatingActionButton = null;
          _scrollPhysics = NeverScrollableScrollPhysics();
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0.0, // The offset to scroll to (0.0 is the top)
              duration: const Duration(milliseconds: 500), // Animation duration
              curve: Curves.easeOut, // Animation curve
            );
          }
        case 1:
          _currentPageIndex = index;
          _currentScreen = EventsScreen();
          _showAppBar = true;
          _appBarLabel = 'Events';
          _useAppBarShadow = true;
          _appBarColor = Colors.transparent;
          _appBarTextColor = Theme.of(context).colorScheme.onSurface;
          _scaffoldBackgroundColor = Theme.of(context).colorScheme.surface;
          _floatingActionButton = null;
          _scrollPhysics = ScrollPhysics();
        case 2:
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => SubmissionSelectionScreen())
          );
        case 3:
          _currentPageIndex = index;
          _currentScreen = SocialScreen();
          _showAppBar = true;
          _appBarLabel = 'Social';
          _useAppBarShadow = true;
          _appBarColor = Theme.of(context).colorScheme.surface;
          _appBarTextColor = Theme.of(context).colorScheme.onSurface;
          _scaffoldBackgroundColor = Theme.of(context).colorScheme.surface;
          _floatingActionButton = FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => PostCreationScreen())
              );
            },
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          );
          _scrollPhysics = ScrollPhysics();
        case 4:
          _currentPageIndex = index;
          _currentScreen = RankingsScreen();
          _showAppBar = true;
          _useAppBarShadow = false;
          _appBarColor = Theme.of(context).colorScheme.primaryContainer;
          _appBarLabel = 'Leaderboard';
          _appBarTextColor = Theme.of(context).colorScheme.tertiary;
          _scaffoldBackgroundColor = Theme.of(context).colorScheme.surface;
          _floatingActionButton = null;
          _scrollPhysics = ScrollPhysics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ref.watch(userProvider);
    users = ref.watch(usersProvider);
    _userSettings = ref.watch(settingsProvider);
    AsyncValue<List<Event>> eventStream = ref.watch(eventProvider);
    AsyncValue<List<(String, int)>> userRankingsStream = ref.watch(userEventRankingsProvider);

    var now = DateTime.now();
    if (eventStream.hasValue) {
      _events = eventStream.value!;
      _currentEvent = _events!.where((e) => e.startDate.isBefore(now) & e.endDate.isAfter(now)).firstOrNull;
    }

    if (userRankingsStream.hasValue) {
      _userRankings = userRankingsStream.value!;
    }

    if (currentUser == null) {
      setState(() {
        _currentScreen = LoadingScreen();
      });
    } else {

      // Check if date has changed and reload events
      _refreshContent();

      // Update user if new event has started
      if (_newEventStarted) {
        if (_showNewEventStartedButton) {
          _dialogBuilder(context);
        }
        // TODO: Move this to utility function on user? (user.startNewEvent?)
        currentUser!.currentEventIndexes = [_currentEvent!.id!];
        currentUser!.currentEventDifficulty = null;
        currentUser!.currentEventPoints = [0];
        UserProvider().setUser(currentUser!);
      }

      // Update last login date
      ref.read(settingsProvider.notifier).updateSettings(_userSettings!);
      onDestinationSelected(_currentPageIndex, context);

      setState(() {
        _newEventStarted = false;
        _showNewEventStartedButton = false;
      });
    }

    Color appBarColor = _appBarColor != null
        ? _appBarColor!
        : Colors.transparent;

    return Scaffold(
      backgroundColor: _scaffoldBackgroundColor,
      endDrawer: DefaultDrawer(),
      floatingActionButton: _floatingActionButton,
      body: NestedScrollView(
        controller: _scrollController,
        physics: _scrollPhysics,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            if (_showAppBar)
              DefaultAppBar(
                label: _appBarLabel,
                useShadow: _useAppBarShadow,
                backgroundColor: appBarColor,
                textColor: _appBarTextColor,
              ),
          ];
        },
        body: _currentScreen
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10
            ),
          ]
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            onDestinationSelected(index, context);
          },
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          shadowColor: Colors.black,
          elevation: 10.0,
          selectedIndex: _currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.calendar_today),
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Events',
            ),
            NavigationDestination(
              icon: Icon(Icons.upload),
              label: 'Submit',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.groups),
              icon: Icon(Icons.groups_outlined),
              label: 'Social',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.emoji_events),
              icon: Icon(Icons.emoji_events_outlined),
              label: 'Rankings',
            ),
          ],
        ),
      ),
    );
  }
}