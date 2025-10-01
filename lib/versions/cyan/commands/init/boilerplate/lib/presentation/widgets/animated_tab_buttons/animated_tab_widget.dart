import 'package:flutter/cupertino.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/models/animated_tab_item_model.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/presentation/widgets/tapper.dart';

part 'tab_item_widget.dart';

class AnimatedTabWidget extends StatelessWidget {
  const AnimatedTabWidget({
    super.key,
    required this.tabs,
    this.onTap,
    this.width,
    this.height,
    required this.selectedTabIndex,
    this.margin = const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
    this.contentPadding = const EdgeInsets.all(6),
    this.useSmallerFonts = true,
    this.disabledTabs = const [],
  });

  final List<AnimatedTabItemModel> tabs;
  final Function(int index)? onTap;
  final int selectedTabIndex;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry contentPadding;
  final List<int> disabledTabs;
  final bool useSmallerFonts;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: context.colors.bgNeutralLight100,
        padding: contentPadding,
        groupValue: selectedTabIndex,
        disabledChildren: disabledTabs.toSet(),
        children: Map.fromEntries(
          tabs.asMap().entries.map(
            (entry) => MapEntry<int, Widget>(
              entry.key,
              _TabItemWidget(
                tab: entry.value,
                isSelected: selectedTabIndex == entry.key,
                labelFontSize: tabs.length > 2
                    ? useSmallerFonts
                          ? 12
                          : 14
                    : 14,
              ),
            ),
          ),
        ),
        onValueChanged: (value) => onTap?.call(value!),
      ),
    );
  }
}
