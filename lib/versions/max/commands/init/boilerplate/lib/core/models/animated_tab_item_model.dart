import 'package:flutter/material.dart';

class AnimatedTabItemModel {
  final String label;
  final IconData? iconData;
  final Function()? onTap;
  final int count;

  const AnimatedTabItemModel({
    required this.label,
    this.iconData,
    this.onTap,
    this.count = 0,
  });
}
