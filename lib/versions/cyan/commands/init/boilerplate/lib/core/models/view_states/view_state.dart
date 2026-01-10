import 'package:equatable/equatable.dart';
import 'package:newarch/core/enums/process_state.dart';

/// 🔥 VIEW STATE - Base class for all view states
abstract class ViewState extends Equatable {
  void dispose();

  ProcessState get status;

  String? get errorMessage;

  bool get isLoading => status == ProcessState.loading;

  bool get hasError => status == ProcessState.error;

  bool get isSuccess => status == ProcessState.success;

  bool get hasData;

  bool get isEmpty;
}
