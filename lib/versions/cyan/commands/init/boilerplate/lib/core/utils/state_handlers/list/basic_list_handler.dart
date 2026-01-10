import 'package:newarch/core/enums/process_state.dart';
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
  });

  final BaseBloc bloc;
  final ListState<T> Function() getViewState;
  final void Function(ListState<T> newViewState) updateViewState;
  final Future<ResponseData<List<T>>> Function() repositoryCall;

  Future<void> load({bool isSilent = false}) async {
    if (bloc.isClosed) return;

    // backup the current state
    final backedUpState = getViewState();

    if (!isSilent) {
      updateViewState(
        backedUpState.copyWith(
          status: ProcessState.loading,
          items: const [],
        ),
      );
    }

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(
        getViewState().copyWith(
          status: ProcessState.error,
          errorMessage: response.message,
          items: const [],
        ),
      );

      return;
    }

    final newItems = response.data!;

    updateViewState(
      getViewState().copyWith(
        status: ProcessState.success,
        items: newItems,
      ),
    );
  }

  Future<void> refresh() async {
    if (bloc.isClosed) return;

    await load();
  }

  Future<void> silentRefresh() async {
    if (bloc.isClosed) return;
    await load(isSilent: true);
  }
}
