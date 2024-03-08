import 'package:flutter/material.dart';

class CoordinatorLayout extends StatefulWidget {
  CoordinatorLayout({
    required this.headerMinHeight,
    required this.headerMaxHeight,
    required this.headers,
    required this.body,
    this.scrollController,
    this.snap = true,
    super.key,
  });
  final List<Widget> headers;
  final Widget body;
  final ScrollController? scrollController;

  final double headerMinHeight;
  final double headerMaxHeight;

  final bool snap;
  @override
  CoordinatorLayoutState createState() => CoordinatorLayoutState();

  static CoordinatorLayoutState? of(BuildContext context) {
    final CoordinatorLayoutState? result = context.findAncestorStateOfType<CoordinatorLayoutState>();
    return result;
  }
}

class CoordinatorLayoutState extends State<CoordinatorLayout> {
  late ScrollController scrollController;
  Future<void>? scrollAnimateToRunning;

  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return buildNestedScrollView();
  }

  Future toggle(double range) async {
    if (scrollController.offset > 0 && scrollController.offset < range) {
      if (scrollAnimateToRunning != null) {
        await scrollAnimateToRunning;
      }

      if (scrollController.offset < range / 2) {
        scrollAnimateToRunning = scrollController.animateTo(0,
            duration: Duration(milliseconds: 100), curve: Curves.ease)
          ..then((value) => scrollController.jumpTo(0));
      } else if (scrollController.offset < range) {
        scrollAnimateToRunning = scrollController.animateTo(range,
            duration: Duration(milliseconds: 100), curve: Curves.ease)
          ..then((value) => scrollController.jumpTo(range));
      }
    }
  }

  bool _handleScrollNotification(scrollNotification) {
    if (scrollNotification is ScrollEndNotification) {
      double range = widget.headerMaxHeight - widget.headerMinHeight;
      toggle(range);
    }
    return false;
  }

  Widget buildNestedScrollView() {
    return NotificationListener<ScrollNotification>(
      onNotification: widget.snap ? _handleScrollNotification : null,
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return widget.headers;
        },
        body: widget.body,
      ),
    );
  }
}
