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
    // profileImageUrl: 'https://www.easychickpeasy.com/wp-content/uploads/2023/02/parsnip-substitutes-1.jpg'
);

User kamala = User(
    userName: 'Kamala Harris',
    email: 'kamala@gmail.com',
    currentCompetitionPoints: [226],
    currentEventPoints: [70],
    friends: ['Biw'],
    submissions: [],
    currentEventDifficulty: [Difficulty.beginner],
    // profileImageUrl: 'https://www.rollingstone.com/wp-content/uploads/2024/07/kamala-harris-memes.jpg?crop=0px%2C86px%2C1798px%2C1014px&resize=1600%2C900'
);

User trump = User(
    userName: 'Donald Trump',
    email: 'trump@gmail.com',
    currentCompetitionPoints: [301],
    currentEventPoints: [65],
    friends: [],
    submissions: [],
    currentEventDifficulty: [Difficulty.beginner],
    // profileImageUrl: 'https://m.media-amazon.com/images/I/71H9VKgKCXL._AC_UF894,1000_QL80_.jpg'
);

User bill = User(
    userName: 'Bill Nye',
    email: 'bill@gmail.com',
    currentCompetitionPoints: [172],
    currentEventPoints: [95],
    friends: ['Biw', 'Kamala Harris'],
    submissions: [],
    currentEventDifficulty: [Difficulty.beginner],
    // profileImageUrl: 'https://i.ytimg.com/vi/iubpN72D6AI/maxresdefault.jpg'
);

List<User> demoUsers = [
  biw,
  kamala,
  trump,
  bill
];