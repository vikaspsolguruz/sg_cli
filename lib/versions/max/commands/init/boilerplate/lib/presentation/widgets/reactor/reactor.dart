import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:max_arch/core/utils/console_print.dart';

part 'reactive.dart';

class Reactor<T extends Reactive> extends StatefulWidget {
  const Reactor({
    super.key,
    required this.model,
    required this.child,
  });

  final T model;
  final Widget child;

  @override
  State<Reactor<T>> createState() => _ReactorState<T>();
}

class _ReactorState<T extends Reactive> extends State<Reactor<T>> {
  @override
  void initState() {
    super.initState();
    widget.model._register();
    widget.model._listen(_rebuild);
  }

  @override
  void dispose() {
    widget.model._unlisten(_rebuild);
    widget.model._unregister();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
