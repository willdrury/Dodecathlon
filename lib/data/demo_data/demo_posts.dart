import 'package:dodecathlon/data/demo_data/demo_users.dart';
import 'package:dodecathlon/models/post.dart';

Post reading1 = Post(
    user: biw,
    title: 'Finished a book!',
    createdAt: DateTime.now(),
    description: 'Just read the grapes of wrath. It was ok',
    imageUrl: 'https://keepingupwiththepenguins.com/wp-content/uploads/2018/12/The-Grapes-Of-Wrath-John-Steinbeck-Book-Laid-on-Wooden-Table-Keeping-Up-With-The-Penguins-676x1014.jpg'
);

Post reading2 = Post(
    user: trump,
    title: 'Finished a book!',
    createdAt: DateTime.now(),
    description: 'Cant recommend this book enough. Must read. Truly one of the greatest.',
    imageUrl: 'https://images.axios.com/OHq21kAFIn4F-mSTTcaa3jk9GvQ=/1920x1080/smart/2017/12/15/1513300122556.jpg?w=3840',
);

Post bookStore = Post(
  user: bill,
  title: 'Visited a bookstore!',
  createdAt: DateTime.now(),
  description: 'Went to the Kings English Bookshop today. It was very cute! Incredible selection, although I wasn\'nt able to find anything on Mario and Sonic at the olympic games...',
  imageUrl: 'https://lh3.googleusercontent.com/p/AF1QipNfibyqy0WVFz_DlDJ9pClGZ2DTOKie5FgJaTvF=s1360-w1360-h1020'
);

List<Post> demoPosts = [
  reading2,
  bookStore,
  reading1,
];