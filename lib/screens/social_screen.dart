import 'package:dodecathlon/data/demo_data/demo_posts.dart';
import 'package:dodecathlon/widgets/post_container.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // SearchAnchor.bar(
                  //     barBackgroundColor: WidgetStatePropertyAll(Colors.white),
                  //     viewBackgroundColor: Colors.transparent,
                  //     suggestionsBuilder: (BuildContext context, SearchController controller) {
                  //       return List<Container>.generate(5, (int index) {
                  //         return Container(height: 20, color: Colors.pink,);
                  //       });
                  //     }),
                  ListView.builder(
                      itemCount: demoPosts.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return PostContainer(post: demoPosts[i]);
                      }
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}