import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:flutter/material.dart';

Event reading = Event(
  name: 'Reading',
  description: 'Start your yearly reading goal off strong by seeing how many books you can complete. See what others are reading, join book clubs, and get cozy!',
  hasMultipleDifficulties: true,
  beginnerDescription: 'I just want to read more',
  intermediateDescription: 'I have a reading goal for the year, but nothing too serious',
  advancedDescription: 'I have a goal of reading 20+ books this year',
  themeColor: Colors.red,
  prize: 'Book Ends',
  icon: Icons.auto_stories,
  startDate: DateTime(2025, 1),
  endDate: DateTime(2025, 2)
);

Challenge beginnerPageCount = Challenge(
    name: 'Read 100 pages',
    id: '10000',
    description: 'Read 100 pages this month',
    event: reading,
    difficulty: Difficulty.beginner,
    maxPoints: 50,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: false,
    isRecurring: false,
    isEditable: true,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge intermediatePageCount = Challenge(
    name: 'Read 500 pages',
    id: '10001',
    description: 'Read 500 this month',
    event: reading,
    difficulty: Difficulty.intermediate,
    maxPoints: 70,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: false,
    isRecurring: false,
    isEditable: true,
    imageUrl: 'https://www.pwcva.gov/assets/2022-11/mikolaj-DCzpr09cTXY-unsplash.jpg',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge advancedPageCount = Challenge(
    name: 'Read 1,000 pages',
    id: '10002',
    description: 'Read 1,000 this month',
    event: reading,
    difficulty: Difficulty.advanced,
    maxPoints: 90,
    scoringMechanism: ScoringMechanism.gradated,
    submissionScreen: SubmissionScreen.pageCount,
    isBonus: false,
    isRecurring: false,
    isEditable: true,
    imageUrl: 'https://www.pwcva.gov/assets/2022-11/mikolaj-DCzpr09cTXY-unsplash.jpg',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge beginnerBook = Challenge(
    name: 'Finish a book',
    id: '10003',
    description: 'Finish a book over 100 pages',
    event: reading,
    difficulty: Difficulty.beginner,
    maxPoints: 50,
    scoringMechanism: ScoringMechanism.completion,
    submissionScreen: SubmissionScreen.bookCompletion,
    isBonus: false,
    isRecurring: false,
    isEditable: false,
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge intermediateFirstBook = Challenge(
    name: 'Read your first book',
    id: '10004',
    description: 'Read 1 book over 200 pages',
    event: reading,
    difficulty: Difficulty.intermediate,
    maxPoints: 45,
    scoringMechanism: ScoringMechanism.completion,
    submissionScreen: SubmissionScreen.bookCompletion,
    isBonus: false,
    isRecurring: false,
    isEditable: false,
    imageUrl: 'https://media.istockphoto.com/id/612523400/photo/one-old-brown-book.jpg?s=612x612&w=0&k=20&c=Cp-hEcRfw1bJApDhpWqPEb4wGr3w1Yt1YdWF7uoidiA=',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge intermediateAdditionalBook = Challenge(
    name: 'Read another book',
    id: '10005',
    description: 'Finish another book of any length',
    event: reading,
    difficulty: Difficulty.intermediate,
    maxPoints: 25,
    scoringMechanism: ScoringMechanism.completion,
    submissionScreen: SubmissionScreen.bookCompletion,
    isBonus: false,
    isRecurring: true,
    isEditable: false,
    imageUrl: 'https://media.istockphoto.com/id/949118068/photo/books.webp?a=1&b=1&s=612x612&w=0&k=20&c=lxb-mHWs3AkeKR-J7ZwD8a5Mo9vmsq3uYPMaJbIUoCI=',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge advancedFirstBook = Challenge(
    name: 'Read your first book',
    id: '10006',
    description: 'Read a book over 300 pages',
    event: reading,
    difficulty: Difficulty.advanced,
    maxPoints: 40,
    scoringMechanism: ScoringMechanism.completion,
    submissionScreen: SubmissionScreen.bookCompletion,
    isBonus: false,
    isRecurring: false,
    isEditable: false,
    imageUrl: 'https://media.istockphoto.com/id/612523400/photo/one-old-brown-book.jpg?s=612x612&w=0&k=20&c=Cp-hEcRfw1bJApDhpWqPEb4wGr3w1Yt1YdWF7uoidiA=',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge advancedAdditionalBook = Challenge(
    name: 'Read another book',
    id: '10007',
    description: 'Finish another book of any length',
    event: reading,
    difficulty: Difficulty.advanced,
    maxPoints: 25,
    scoringMechanism: ScoringMechanism.completion,
    submissionScreen: SubmissionScreen.bookCompletion,
    isBonus: false,
    isRecurring: true,
    isEditable: false,
    imageUrl: 'https://media.istockphoto.com/id/949118068/photo/books.webp?a=1&b=1&s=612x612&w=0&k=20&c=lxb-mHWs3AkeKR-J7ZwD8a5Mo9vmsq3uYPMaJbIUoCI=',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge bookClub = Challenge(
    name: 'Attend a Book Club Meeting',
    id: '10008',
    description: 'Attend at least one book club meeting this month. May be online or in-person',
    event: reading,
    difficulty: Difficulty.all,
    maxPoints: 5,
    scoringMechanism: ScoringMechanism.completion,
    submissionScreen: SubmissionScreen.inPersonEventAttendance,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    imageUrl: 'https://image.cnbcfm.com/api/v1/image/104702698-GettyImages-583816330-book-club.jpg?v=1532563764&w=1480&h=833&ffmt=webp&vtcrop=y',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge bookReview = Challenge(
    name: 'Write a Book Review',
    id: '10009',
    description: 'Write a 300+ word book review and post it to the app',
    event: reading,
    difficulty: Difficulty.all,
    maxPoints: 5,
    scoringMechanism: ScoringMechanism.completion,
    submissionScreen: SubmissionScreen.writtenReview,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    imageUrl: 'https://negativespace.co/wp-content/uploads/2018/05/negative-space-drawing-pencils-white-paper-rawpixel-thumb-1.jpg',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime(2025, 2)
);

Challenge bonusReading1 = Challenge(
    name: 'Read This!',
    id: '10010',
    description: 'Read the following article and answer questions for bonus points!',
    event: reading,
    difficulty: Difficulty.all,
    maxPoints: 5,
    scoringMechanism: ScoringMechanism.completion,
    enforcement: Enforcement.quiz,
    submissionScreen: SubmissionScreen.quiz,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    imageUrl: 'https://miro.medium.com/v2/resize:fit:4800/format:webp/1*42ebJizcUtZBNIZPmmMZ5Q.jpeg',
    startDate: DateTime.utc(2025, 1, 4),
    endDate: DateTime.utc(2025, 1, 5, 23, 59, 59)
);

Challenge bonusReading2 = Challenge(
    name: 'Read This!',
    id: '10011',
    description: 'Read the following article and answer questions for bonus points!',
    event: reading,
    difficulty: Difficulty.all,
    maxPoints: 5,
    scoringMechanism: ScoringMechanism.completion,
    enforcement: Enforcement.quiz,
    submissionScreen: SubmissionScreen.quiz,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    imageUrl: 'https://publishyourpurpose.com/wp-content/uploads/2022/07/how-many-pages-good-book-publish-your-purpose.png',
    startDate: DateTime.utc(2025, 1, 11),
    endDate: DateTime.utc(2025, 1, 12, 23, 59, 59)
);

Challenge bonusReading3 = Challenge(
    name: 'Read This!',
    id: '10012',
    description: 'Read the following article and answer questions for bonus points!',
    event: reading,
    difficulty: Difficulty.all,
    maxPoints: 5,
    scoringMechanism: ScoringMechanism.completion,
    enforcement: Enforcement.quiz,
    submissionScreen: SubmissionScreen.quiz,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    startDate: DateTime.utc(2025, 1, 18),
    endDate: DateTime.utc(2025, 1, 19, 23, 59, 59)
);

Challenge bonusReading4 = Challenge(
    name: 'Read This!',
    id: '10013',
    description: 'Read the following article and answer questions for bonus points!',
    event: reading,
    difficulty: Difficulty.all,
    maxPoints: 5,
    scoringMechanism: ScoringMechanism.completion,
    enforcement: Enforcement.quiz,
    submissionScreen: SubmissionScreen.quiz,
    isBonus: true,
    isRecurring: false,
    isEditable: false,
    imageUrl: 'https://miro.medium.com/v2/resize:fit:4800/format:webp/1*42ebJizcUtZBNIZPmmMZ5Q.jpeg',
    startDate: DateTime.utc(2024, 1, 25),
    endDate: DateTime.utc(2025, 1, 26, 23, 59, 59)
);

List<Challenge> readingChallenges = [
  beginnerPageCount,
  beginnerBook,
  intermediatePageCount,
  intermediateFirstBook,
  intermediateAdditionalBook,
  advancedPageCount,
  advancedFirstBook,
  advancedAdditionalBook,
  bonusReading1,
  bookReview,
  bookClub,
  bonusReading2,
  bonusReading3,
  bonusReading4
];