import 'package:flutter/material.dart';

class CoordinatorLayout extends StatefulWidget {
  CoordinatorLayout({
    @required this.headerMinHeight,
    @required this.headerMaxHeight,
    @required this.headers,
    this.body,
    this.scrollController,
    this.snap = true,
    Key key,
  }) : super(key: key);
  final List<Widget> headers;
  final Widget body;
  final ScrollController scrollController;

  final double headerMinHeight;
  final double headerMaxHeight;

  final bool snap;
  @override
  CoordinatorLayoutState createState() => CoordinatorLayoutState();

  static CoordinatorLayoutState of(BuildContext context,
      {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final CoordinatorLayoutState result =
        context.findAncestorStateOfType<CoordinatorLayoutState>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'CoordinatorLayoutState.of() called with a context that does not contain a CoordinatorLayoutState.'),
      ErrorDescription(
          'No CoordinatorLayoutState ancestor could be found starting from the context that was passed to CoordinatorLayoutState.of(). '
          'This usually happens when the context provided is from the same StatefulWidget as that '
          'whose build function actually creates the CoordinatorLayoutState widget being sought.'),
      ErrorHint(
          'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
          'context that is "under" the CoordinatorLayoutState. For an example of this, please see the '
          'documentation for CoordinatorLayoutState.of():\n'
          '  https://api.flutter.dev/flutter/material/CoordinatorLayoutState/of.html'),
      ErrorHint(
          'A more efficient solution is to split your build function into several widgets. This '
          'introduces a new context from which you can obtain the CoordinatorLayoutState. In this solution, '
          'you would have an outer widget that creates the CoordinatorLayoutState populated by instances of '
          'your new inner widgets, and then in these inner widgets you would use CoordinatorLayoutState.of().\n'
          'A less elegant but more expedient solution is assign a GlobalKey to the CoordinatorLayoutState, '
          'then use the key.currentState property to obtain the CoordinatorLayoutStateState rather than '
          'using the CoordinatorLayoutState.of() function.'),
      context.describeElement('The context used was')
    ]);
  }
}

class CoordinatorLayoutState extends State<CoordinatorLayout> {
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return buildNestedScrollView();
  }

  Future<void> scrollAnimateToRunning;

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
