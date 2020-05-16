import 'dart:math';

import 'package:coordinator_layout/coordinator_layout.dart';
import 'package:flutter/material.dart';

typedef CollapseWidgetBuilder = Widget Function(
    BuildContext context, double offset, double diffPixel);

class SliverCollapsingHeader extends SliverPersistentHeader {
  SliverCollapsingHeader({
    @required this.builder,
  }) : super(
          pinned: true,
          floating: true,
          delegate: SliverCollapseHeaderDelegate(
            builder: builder,
          ),
        );

  final CollapseWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    CoordinatorLayout _layout = CoordinatorLayout.of(context).widget;
    SliverCollapseHeaderDelegate delegate = super.delegate;
    delegate.minHeight = _layout.headerMinHeight;
    delegate.maxHeight = _layout.headerMaxHeight;
    return super.build(context);
  }
}

class SliverCollapseHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverCollapseHeaderDelegate({
    @required this.builder,
  });
  double minHeight;
  double maxHeight;
  final CollapseWidgetBuilder builder;

  @override
  double get minExtent => this.minHeight;
  @override
  double get maxExtent => this.maxHeight;

  double offset = 0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double diffPixel = (this.maxExtent - this.minExtent);
    double offset = shrinkOffset / diffPixel;
    return builder(context, min(1, offset), diffPixel);
  }

  @override
  bool shouldRebuild(SliverCollapseHeaderDelegate oldDelegate) {
    return true;
  }
}
