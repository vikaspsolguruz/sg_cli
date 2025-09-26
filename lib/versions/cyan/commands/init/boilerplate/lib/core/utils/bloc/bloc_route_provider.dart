import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newarch/app/app_state.dart';
import 'package:newarch/core/utils/bloc/base_bloc.dart';

class BlocRouteProvider<T extends BaseBloc> extends StatelessWidget {
  final Widget page;
  final T Function(BuildContext context) bloc;

  const BlocRouteProvider({super.key, required this.page, required this.bloc});

  @override
  Widget build(BuildContext routeContext) {
    return BlocProvider<T>(
      create: (blocContext) {
        AppState.applyNewSettingsFor(routeContext);
        return bloc(blocContext)..attachContext(routeContext);
      },
      lazy: false,
      child: page,
    );
  }
}
