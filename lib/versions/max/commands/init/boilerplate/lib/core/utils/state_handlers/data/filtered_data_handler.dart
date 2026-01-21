import 'package:max_arch/core/constants/app_strings.dart';
import 'package:max_arch/core/enums/process_state.dart';
import 'package:max_arch/core/models/filter_model.dart';
import 'package:max_arch/core/models/response/normal_response_model.dart';
import 'package:max_arch/core/models/view_states/data_state_with_filter.dart';
import 'package:max_arch/core/models/wrapped_model.dart';
import 'package:max_arch/core/utils/bloc/base_bloc.dart';

/// 🔥 FILTERED DATA HANDLER - Single object with filter support
///
/// < DataType, FilterType >
class FilteredDataHandler<D, F extends FilterModel> {
  FilteredDataHandler({
    required this.bloc,
    required this.getViewState,
    required this.updateViewState,
    required this.repositoryCall,
  });

  final BaseBloc bloc;
  final DataStateWithFilter<D, F> Function() getViewState;
  final void Function(DataStateWithFilter<D, F> newViewState) updateViewState;
  final Future<NormalResponse<D>> Function() repositoryCall;

  Future<void> load({bool isRefresh = false, bool isSilent = false}) async {
    if (bloc.isClosed) return;

    // backup used if using silentRefresh
    final backedUpState = getViewState();

    updateViewState(
      backedUpState.copyWith(
        state: isSilent ? null : ProcessState.loading, // null keeps current status
        data: isSilent ? null : Wrapped.value(null),
      ),
    );

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(
        getViewState().copyWith(
          state: ProcessState.error,
          errorMessage: response.message,
          data: Wrapped.value(null),
        ),
      );

      return;
    }

    final newData = response.data;
    if (newData != null) {
      updateViewState(
        getViewState().copyWith(
          state: ProcessState.success,
          data: Wrapped.value(newData),
        ),
      );
    } else {
      updateViewState(
        getViewState().copyWith(
          state: ProcessState.error,
          errorMessage: response.message ?? AppStrings.somethingWentWrong,
          data: Wrapped.value(null),
        ),
      );
    }
  }

  Future<void> refresh() async {
    if (bloc.isClosed) return;

    await load(isRefresh: true);
  }

  Future<void> silentRefresh() async {
    if (bloc.isClosed) return;

    await load(isRefresh: true, isSilent: true);
  }

  Future<void> updateFilter(F newFilter) async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(currentState.copyWith(filter: newFilter));
    await load();
  }

  Future<void> clearFilters() async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(currentState.copyWith(filter: currentState.filter.clear() as F));
    await load();
  }

  Future<void> search() async {
    if (bloc.isClosed) return;

    updateViewState(
      getViewState().copyWith(
        state: ProcessState.loading,
      ),
    );

    await load();
  }
}
