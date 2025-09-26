import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newarch/core/models/view_states/view_state.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc<BlocEvent, State> extends Bloc<BlocEvent, State> {
  BaseBloc(super.initialState) {
    eventListeners();
    initState();
  }

  late BuildContext _context;

  @protected
  List<ViewState> get viewStates => const [];

  @protected
  BuildContext get context => _context;

  @protected
  Map<String, dynamic>? get arguments => _context.arguments;

  void attachContext(BuildContext context) {
    _context = context;
  }

  @protected
  void initState() {}

  void eventListeners();

  @override
  Future<void> close() {
    for (final viewState in viewStates) {
      viewState.dispose();
    }
    return super.close();
  }
}

EventTransformer<E> debounce<E>({
  Duration duration = const Duration(milliseconds: 1000),
}) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
