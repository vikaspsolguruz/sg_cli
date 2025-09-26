import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({
    super.key,
    this.size = 30,
    this.visible = true,
    this.onBuild,
    this.progress,
  });

  final double size;
  final bool visible;
  final void Function()? onBuild;
  final int? progress;

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  @override
  void initState() {
    widget.onBuild?.call();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox();
    return Center(
      child: Container(
        height: widget.size,
        width: widget.size,
        margin: const EdgeInsets.all(10),
        child: Platform.isIOS && widget.progress == null
            ? const FittedBox(child: CupertinoActivityIndicator())
            : CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: widget.size * 0.1,
                strokeCap: StrokeCap.round,
                value: widget.progress != null ? widget.progress! / 100 : null,
              ),
      ),
    );
  }
}
