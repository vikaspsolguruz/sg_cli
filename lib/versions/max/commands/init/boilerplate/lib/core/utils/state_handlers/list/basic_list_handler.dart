import 'package:max_arch/core/enums/process_state.dart';
import 'package:max_arch/core/models/response/normal_response_model.dart';
import 'package:max_arch/core/models/view_states/list_state.dart';
import 'package:max_arch/core/utils/bloc/base_bloc.dart';

/// 🔥 BASIC LIST HANDLER - Simple list without pagination/search/filter
///
/// < ItemType >
class BasicListHandler<I> {
  BasicListHandler({
    required this.bloc,
    required this.getViewState,
    required this.updateViewState,
    required this.repositoryCall,
  });

  final BaseBloc bloc;
  final ListState<I> Function() getViewState;
  final void Function(ListState<I> newViewState) updateViewState;
  final Future<NormalResponse<List<I>>> Function() repositoryCall;

  Future<void> load({bool isSilent = false}) async {
    if (bloc.isClosed) return;

    // backup the current state
    final backedUpState = getViewState();

    if (!isSilent) {
      updateViewState(
        backedUpState.copyWith(
          state: ProcessState.loading,
          items: const [],
        ),
      );
    }

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(
        getViewState().copyWith(
          state: ProcessState.error,
          errorMessage: response.message,
          items: const [],
        ),
      );

      return;
    }

    final newItems = response.data!;

    updateViewState(
      getViewState().copyWith(
        state: ProcessState.success,
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
