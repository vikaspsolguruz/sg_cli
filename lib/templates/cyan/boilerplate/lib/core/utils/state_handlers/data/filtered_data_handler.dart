import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/models/filter_model.dart';
import 'package:newarch/core/models/response_data_model.dart';
import 'package:newarch/core/models/view_states/data_state_with_filter.dart';
import 'package:newarch/core/utils/bloc/base_bloc.dart';

/// 🔥 FILTERED DATA HANDLER - Single object with filter support
class FilteredDataHandler<T, F extends FilterModel> {
  FilteredDataHandler({
    required this.bloc,
    required this.getViewState,
    required this.updateViewState,
    required this.repositoryCall,
  });

  final BaseBloc bloc;
  final DataStateWithFilter<T, F> Function() getViewState;
  final void Function(DataStateWithFilter<T, F> newViewState) updateViewState;
  final Future<ResponseData<T>> Function({required F filter}) repositoryCall;

  Future<void> load({bool isRefresh = false}) async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(
      DataStateWithFilter<T, F>.loading(
        currentData: isRefresh ? null : currentState.data,
        filter: currentState.filter,
        existingController: currentState.searchController,
      ),
    );

    final response = await repositoryCall(filter: currentState.filter);

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(
        DataStateWithFilter<T, F>.error(
          error: response.message!,
          currentData: currentState.data,
          filter: currentState.filter,
          searchController: currentState.searchController,
        ),
      );
      return;
    }

    final newData = response.data;
    if (newData != null) {
      updateViewState(
        DataStateWithFilter<T, F>.success(
          newData,
          filter: currentState.filter,
          searchController: currentState.searchController,
        ),
      );
    } else {
      updateViewState(
        DataStateWithFilter<T, F>.error(
          error: response.message ?? AppStrings.somethingWentWrong,
          filter: currentState.filter,
          currentData: currentState.data,
          searchController: currentState.searchController,
        ),
      );
    }
  }

  Future<void> refresh() async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(
      DataStateWithFilter<T, F>.initial(
        createInitialFilter: () => currentState.filter,
        hasSearch: currentState.hasSearch,
      ),
    );
    await load(isRefresh: true);
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
}
