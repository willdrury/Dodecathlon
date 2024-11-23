import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/screens/loading_screen.dart';
import 'package:dodecathlon/utilities/custom_color_extension.dart';
import 'package:dodecathlon/widgets/default_app_bar.dart';
import 'package:dodecathlon/widgets/default_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dodecathlon/screens/submission_selection_screen.dart';
import 'package:dodecathlon/screens/events_screen.dart';
import 'package:dodecathlon/screens/leaderboard_screen.dart';
import 'package:dodecathlon/screens/social_screen.dart';
import 'package:dodecathlon/screens/home_screen.dart';
import 'package:dodecathlon/data/demo_data/demo_users.dart';

class MainScreen extends ConsumerStatefulWidget {
  MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends ConsumerState<MainScreen> {

  late Widget _currentScreen;
  int _currentPageIndex = 0;
  bool _showAppBar = true;
  bool _useAppBarShadow = true;
  Color? _appBarColor;
  late String _appBarLabel = 'Home';
  late User? currentUser;
  late List<User> users;

  @override
  void initState() {
    super.initState();
    currentUser = ref.read(userProvider);
    users = ref.read(usersProvider);
    if (currentUser == null) {
      _currentScreen = LoadingScreen();
    } else  {
      _currentScreen = HomeScreen(user: currentUser!, users: users,);
      print('users: $users');
    }
  }

  void _onDestinationSelected(int index) async {
    List<Submission>? userSubmissions = currentUser!.submissionData;
    if (currentUser!.submissionData == null){
      userSubmissions = await currentUser!.getSubmissions();
    }
    setState(() {
      switch (index) {
        case 0:
          _currentPageIndex = index;
          _currentScreen = HomeScreen(user: currentUser!, users: users,);
          _showAppBar = true;
          _appBarLabel = 'Home';
          _useAppBarShadow = true;
          _appBarColor = null;
        case 1:
          _currentPageIndex = index;
          _currentScreen = EventsScreen(submissions: userSubmissions!,);
          _showAppBar = true;
          _appBarLabel = '';
          _useAppBarShadow = false;
          _appBarColor = Colors.white;
        case 2:
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => SubmissionSelectionScreen(userSubmissions: userSubmissions!,))
          );
        case 3:
          _currentPageIndex = index;
          _currentScreen = SocialScreen();
          _showAppBar = true;
          _appBarLabel = 'Social';
          _useAppBarShadow = true;
        case 4:
          _currentPageIndex = index;
          _currentScreen = LeaderboardScreen(currentUser: currentUser!, users: users,);
          _showAppBar = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ref.watch(userProvider);
    users = ref.watch(usersProvider);


    if(currentUser != null) {
      _onDestinationSelected(_currentPageIndex);
    }

    CustomColorsExtension customColors = Theme.of(context).extension<CustomColorsExtension>()!;

    Color appBarColor = _appBarColor != null
        ? _appBarColor!
        // : customColors.primaryDim;
        : Colors.transparent;

    return Scaffold(
      endDrawer: DefaultDrawer(),
      body: NestedScrollView(
        floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              if (_showAppBar)
                DefaultAppBar(label: _appBarLabel, useShadow: _useAppBarShadow, backgroundColor: appBarColor,),
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
          onDestinationSelected: _onDestinationSelected,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Colors.white,
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