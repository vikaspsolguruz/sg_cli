import 'package:newarch/core/models/response_data_model.dart';
import 'package:newarch/core/models/view_states/list_state.dart';
import 'package:newarch/core/utils/bloc/base_bloc.dart';

/// 🔥 BASIC LIST HANDLER - Simple list without pagination/search/filter
class BasicListHandler<T> {
  BasicListHandler({
    required this.bloc,
    required this.getViewState,
    required this.updateViewState,
    required this.repositoryCall,
    this.onLoadMoreRetry,
  });

  final BaseBloc bloc;
  final ListState<T> Function() getViewState;
  final void Function(ListState<T> newViewState) updateViewState;
  final Future<ResponseData<List<T>>> Function() repositoryCall;
  final void Function()? onLoadMoreRetry;

  Future<void> load({bool isRefresh = false}) async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(ListState<T>.loading(currentItems: isRefresh ? null : currentState.items));

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(ListState<T>.error(error: response.message!, currentItems: currentState.items));
      return;
    }

    final newItems = response.data!;
    updateViewState(ListState<T>.success(items: newItems));
  }

  Future<void> refresh() async {
    if (bloc.isClosed) return;
    updateViewState(ListState<T>.initial());
    await load(isRefresh: true);
  }
}
