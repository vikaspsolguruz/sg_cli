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

  Future<void> load({bool isRefresh = false, bool isSilent = false}) async {
    if (bloc.isClosed) return;

    // backup used if using silentRefresh
    final backedUpState = getViewState();

    updateViewState(
      backedUpState.copyWith(
        status: isSilent ? null : ProcessState.loading,
        items: isSilent ? backedUpState.items : const [],
      ),
    );

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

    await load(isRefresh: true);
  }

  Future<void> silentRefresh() async {
    if (bloc.isClosed) return;

    await load(isRefresh: true, isSilent: true);
  }
}
