
import 'dart:math';

import 'package:flutter/Material.dart';

class HomeScreenBackground extends StatefulWidget {
  const HomeScreenBackground({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenBackgroundState();
  }
}

/// A simple data class to track the state of each bubble.
class Bubble {
  double x;
  double y;
  double speed;
  double size;
  IconData icon;
  double opacity;

  Bubble({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.icon,
    required this.opacity,
  });
}

class HomeScreenBackgroundState extends State<HomeScreenBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Bubble> _bubbles = [];
  final Random _random = Random();
  Size? _screenSize;

  // Icons that fit the "Dodecathlon" theme
  final List<IconData> _icons = [
    Icons.fitness_center,
    Icons.directions_run,
    Icons.help_outline,
    Icons.emoji_events,
    Icons.book,
    Icons.self_improvement,
    Icons.edit,
    Icons.sports_baseball,
    Icons.rowing,
    Icons.pool,
    Icons.golf_course,
    Icons.free_breakfast
  ];

  @override
  void initState() {
    super.initState();

    // The controller drives the animation loop. 
    // We use a listener to update positions every frame.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateBubbles)
      ..repeat();
  }

  /// Called 60 times a second by the AnimationController.
  void _updateBubbles() {
    if (_screenSize == null) return;

    setState(() {
      for (var bubble in _bubbles) {
        // Move bubble up
        bubble.y -= bubble.speed;
        bubble.opacity = bubble.opacity - .00001;

        // If it goes off the top (with a small buffer), reset it to the bottom
        if (bubble.y < -60 || bubble.opacity <= 0) {
          _resetBubble(bubble);
        }
      }
    });
  }

  /// Initializes the bubbles. Only runs once when the screen size is first determined.
  void _initBubbles(Size size) {
    if (_bubbles.isNotEmpty) {
      _screenSize = size;
      return;
    }

    _screenSize = size;
    for (int i = 0; i < 30; i++) {
      _bubbles.add(_createBubble(size, isInitial: true));
    }
  }

  /// Creates a new bubble configuration. 
  /// [isInitial] spreads bubbles across the screen at startup.
  Bubble _createBubble(Size size, {bool isInitial = false}) {
    return Bubble(
      x: _random.nextDouble() * size.width,
      y: isInitial ? _random.nextDouble() * size.height : size.height + 60,
      speed: 0.1 + _random.nextDouble() * .1,
      size: 15.0 + _random.nextDouble() * 30.0,
      icon: _icons[_random.nextInt(_icons.length)],
      opacity: 0.01 + _random.nextDouble() * 0.1, // Keep them subtle as a background
    );
  }

  /// Moves an existing bubble back to the bottom with fresh random properties.
  void _resetBubble(Bubble bubble) {
    if (_screenSize == null) return;
    final newConfig = _createBubble(_screenSize!);
    bubble.x = newConfig.x;
    bubble.y = newConfig.y;
    bubble.speed = newConfig.speed;
    bubble.size = newConfig.size;
    bubble.icon = newConfig.icon;
    bubble.opacity = newConfig.opacity;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ensure bubbles are initialized with current constraints
        _initBubbles(Size(constraints.maxWidth, constraints.maxHeight));

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                // color: Color(0xFFFF6665).withAlpha(10),
                // color: Theme.of(context).colorScheme.primary.withAlpha(10)
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, .7],
                  colors: [
                    Color.lerp(Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.inverseSurface, .5)!,
                    Theme.of(context).colorScheme.surface,
                  ]
                )
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Color(0xFFFF6665).withAlpha(10),
                //     Color(0xFFFF77B6).withAlpha(10),
                //     Color(0xFFFF6665).withAlpha(10)
                //   ]
                // )
              )
            ),
            // for (var bubble in _bubbles)
            //   Positioned(
            //     left: bubble.x,
            //     top: bubble.y,
            //     child: Opacity(
            //       opacity: bubble.opacity,
            //       child: Icon(
            //         bubble.icon,
            //         size: bubble.size,
            //         color: Colors.white, // Using your requested color
            //       ),
            //     ),
            // ),
          ]
        );
      },
    );
  }
}