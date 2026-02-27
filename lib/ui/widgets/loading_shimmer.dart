import 'package:flutter/material.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// The visual shape of the shimmer placeholder.
enum ShimmerType {
  /// Card-shaped rows for list views.
  list,

  /// Text-block placeholders for detail views.
  detail,
}

/// A shimmer loading placeholder that mimics the shape
/// of the content being loaded.
class LoadingShimmer extends StatelessWidget {
  /// Creates a [LoadingShimmer].
  const LoadingShimmer({
    this.itemCount = 5,
    this.type = ShimmerType.list,
    super.key,
  });

  /// Number of placeholder items to show.
  final int itemCount;

  /// The shimmer layout type.
  final ShimmerType type;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kcVeryLightGrey,
      highlightColor: Colors.white,
      child: type == ShimmerType.list
          ? _buildListShimmer()
          : _buildDetailShimmer(),
    );
  }

  Widget _buildListShimmer() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 12),
      itemBuilder: (_, __) => _ShimmerCard(),
    );
  }

  Widget _buildDetailShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ShimmerTextBlock(
              widthFraction:
                  index == 0 ? 0.6 : 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _ShimmerTextBlock extends StatelessWidget {
  const _ShimmerTextBlock({
    this.widthFraction = 1.0,
  });

  final double widthFraction;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFraction,
      child: Container(
        height: 16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
