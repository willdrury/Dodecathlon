import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/screens/loading_screen.dart';
import 'package:dodecathlon/screens/post_creation_screen.dart';
import 'package:dodecathlon/widgets/default_app_bar.dart';
import 'package:dodecathlon/widgets/default_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dodecathlon/screens/submission_selection_screen.dart';
import 'package:dodecathlon/screens/events_screen.dart';
import 'package:dodecathlon/screens/leaderboard_screen.dart';
import 'package:dodecathlon/screens/social_screen.dart';
import 'package:dodecathlon/screens/home_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends ConsumerState<MainScreen> {

  late Widget _currentScreen = HomeScreen();
  int _currentPageIndex = 0;
  bool _showAppBar = true;
  bool _useAppBarShadow = false;
  Color? _appBarColor;
  String _appBarLabel = '';
  Color _appBarTextColor = Colors.black;
  Color _scaffoldBackgroundColor = Colors.white;
  Widget? _floatingActionButton;
  ScrollPhysics _scrollPhysics = NeverScrollableScrollPhysics();
  late ScrollController _scrollController;
  late User? currentUser;
  late AsyncValue<List<User>> users;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  void _onDestinationSelected(int index, BuildContext ctx) async {
    setState(() {
      switch (index) {
        case 0:
          _currentPageIndex = index;
          _currentScreen = HomeScreen();
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
          _currentScreen = LeaderboardScreen(currentUser: currentUser!, users: users.value!,);
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
    if (currentUser == null) {
      setState(() {
        _currentScreen = LoadingScreen();
      });
    } else {
      _onDestinationSelected(_currentPageIndex, context);
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
            _onDestinationSelected(index, context);
          },
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Theme.of(context).colorScheme.surface,
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