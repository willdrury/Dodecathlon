import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/user.dart';

User biw = User(
    userName: 'Biw',
    email: 'biw@gmail.com',
    currentCompetitionPoints: [521],
    currentEventPoints: [90],
    friends: ['Kamala Harris', 'Bill Nye'],
    submissions: [],
    currentEventDifficulty: [Difficulty.beginner],
    likedPostIds: []
);

User kamala = User(
    userName: 'Kamala Harris',
    email: 'kamala@gmail.com',
    currentCompetitionPoints: [226],
    currentEventPoints: [70],
    friends: ['Biw'],
    submissions: [],
    currentEventDifficulty: [Difficulty.beginner],
    likedPostIds: []
);

User trump = User(
    userName: 'Donald Trump',
    email: 'trump@gmail.com',
    currentCompetitionPoints: [301],
    currentEventPoints: [65],
    friends: [],
    submissions: [],
    currentEventDifficulty: [Difficulty.beginner],
    likedPostIds: []
);

User bill = User(
    userName: 'Bill Nye',
    email: 'bill@gmail.com',
    currentCompetitionPoints: [172],
    currentEventPoints: [95],
    friends: ['Biw', 'Kamala Harris'],
    submissions: [],
    currentEventDifficulty: [Difficulty.beginner],
    likedPostIds: []
);

List<User> demoUsers = [
  biw,
  kamala,
  trump,
  bill
];