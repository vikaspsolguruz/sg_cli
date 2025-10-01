part of 'animated_tab_widget.dart';

class _TabItemWidget extends StatelessWidget {
  const _TabItemWidget({
    required this.isSelected,
    required this.tab,
    this.onTap,
    this.labelFontSize = 14,
    super.key,
  });

  final AnimatedTabItemModel tab;
  final Function()? onTap;
  final double labelFontSize;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Tapper(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.iconData != null) ...[
              Icon(
                tab.iconData,
                color: isSelected ? context.colors.iconNeutralDefault : context.colors.strokeNeutralDefault,
                size: 20,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              tab.label,
              style: AppTextStyles.p3Medium.copyWith(
                color: isSelected ? context.colors.textNeutralPrimary : context.colors.textNeutralSecondary,
                fontSize: labelFontSize,
              ),
            ),
            if (tab.count != 0) ...[
              const SizedBox(width: 8),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: context.colors.bgBrandLight50,
                ),
                child: Center(
                  child: Text(
                    tab.count.toString().padLeft(tab.count < 100 ? 2 : 0, '0'),
                    style: AppTextStyles.p4Medium.copyWith(
                      color: context.colors.textBrandSecondary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
