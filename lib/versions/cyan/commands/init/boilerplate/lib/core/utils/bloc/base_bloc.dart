import 'dart:async';

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

EventTransformer<E> smartDebounce<E>({
  Duration duration = const Duration(milliseconds: 400),
}) {
  return (events, mapper) {
    return events
        .transform(
          StreamTransformer<E, E>.fromBind((stream) {
            Timer? debounceTimer;
            E? pendingEvent;
            bool isIdle = true;
            final controller = StreamController<E>.broadcast();

            return Stream.fromFuture(Future.value()).asyncExpand((_) async* {
              await for (final event in stream) {
                if (isIdle) {
                  // First event when idle: execute immediately
                  isIdle = false;
                  yield event;

                  // Start debounce timer
                  debounceTimer?.cancel();
                  debounceTimer = Timer(duration, () {
                    // Timer expired: execute pending event if any, then reset to idle
                    if (pendingEvent != null) {
                      controller.add(pendingEvent as E);
                    }
                    isIdle = true;
                    debounceTimer = null;
                  });
                } else {
                  // During active period: store the event
                  pendingEvent = event;

                  // Reset the debounce timer
                  debounceTimer?.cancel();
                  debounceTimer = Timer(duration, () {
                    // Timer expired: execute the pending event and reset
                    if (pendingEvent != null) {
                      final eventToEmit = pendingEvent!;
                      pendingEvent = null;
                      controller.add(eventToEmit);
                    }
                    isIdle = true;
                    debounceTimer = null;
                  });
                }
              }
              controller.stream.listen((event) => controller.add(event));
            });
          }),
        )
        .flatMap(mapper);
  };
}
