import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/models/response_data_model.dart';
import 'package:newarch/core/models/view_states/data_state.dart';
import 'package:newarch/core/utils/bloc/base_bloc.dart';

/// 🔥 BASIC DATA HANDLER (WITHOUT FILTER)
class BasicDataHandler<T> {
  BasicDataHandler({
    required this.bloc,
    required this.getViewState,
    required this.updateViewState,
    required this.repositoryCall,
  });

  final BaseBloc bloc;
  final DataState<T> Function() getViewState;
  final void Function(DataState<T> newViewState) updateViewState;
  final Future<ResponseData<T>> Function() repositoryCall;

  Future<void> load({bool isRefresh = false}) async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(DataState<T>.loading(currentData: isRefresh ? null : currentState.data));

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(DataState<T>.error(error: response.message!, currentData: currentState.data));
      return;
    }

    final newData = response.data;
    if (newData != null) {
      updateViewState(DataState<T>.success(newData));
    } else {
      updateViewState(DataState<T>.error(error: response.message ?? AppStrings.somethingWentWrong, currentData: currentState.data));
    }
  }

  Future<void> refresh() async {
    if (bloc.isClosed) return;
    updateViewState(DataState<T>.initial());
    await load(isRefresh: true);
  }
}
