// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'resource_page_view.dart';
import 'visible_resource_range.dart';

class ResourceScrollPhysics extends ScrollPhysics {
  const ResourceScrollPhysics(this.visibleRangeListenable, {super.parent});

  final ValueListenable<VisibleResourceRange> visibleRangeListenable;
  VisibleResourceRange get visibleRange => visibleRangeListenable.value;

  @override
  ResourceScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      ResourceScrollPhysics(
        visibleRangeListenable,
        parent: buildParent(ancestor),
      );

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (position is! MultiResourceScrollPosition) {
      throw ArgumentError(
        'ResourceScrollPhysics must be used with MultiDateScrollPosition.',
      );
    }

    final page = position.pixelsToPage(value);
    final overscrollPages = visibleRange.applyBoundaryConditions(page);
    final overscroll = position.pageDeltaToPixelDelta(overscrollPages);

    // Flutter doesn't allow boundary conditions to apply greater differences
    // than the actual delta. Due to numbers having a limited precision, this
    // occurs fairly often after conversion between pixels and pages, hence we
    // clamp the final value.
    final maximumDelta = (value - position.pixels).abs();
    return overscroll.clamp(-maximumDelta, maximumDelta);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if (position is! MultiResourceScrollPosition) {
      throw ArgumentError(
        'ResourceScrollPhysics must be used with MultiResourceScrollPosition.',
      );
    }

    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    return super.createBallisticSimulation(position, velocity);
  }

  @override
  bool get allowImplicitScrolling => false;
}
