import 'package:flutter/material.dart';

class SocialFiltersCarousel extends StatefulWidget {
  const SocialFiltersCarousel({
    super.key,
    required this.toggleFilter,
  });

  final Function(String) toggleFilter;

  @override
  State<StatefulWidget> createState() {
    return _SocialFiltersCarouselState();
  }
}

class _SocialFiltersCarouselState extends State<SocialFiltersCarousel> {

  Map<String, bool> filters = {
    'Needs Approval': false,
    'Friends': false,
    'Event Submissions': false,
    'Non-Event Submissions': false
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (String s in filters.keys)
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          filters[s] = !filters[s]!;
                          widget.toggleFilter(s);
                        });
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: filters[s]! ? Theme.of(context).colorScheme.secondaryContainer : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: filters[s]! ? Colors.transparent : Colors.black12)
                        ),
                        child: Text(
                          s,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: filters[s]! ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,)
                ],
              ),
          ],
        ),
      ),
    );
  }
}