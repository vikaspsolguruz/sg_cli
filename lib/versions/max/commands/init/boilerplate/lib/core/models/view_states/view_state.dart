import 'package:equatable/equatable.dart';
import 'package:max_arch/core/enums/process_state.dart';

/// 🔥 VIEW STATE - Base class for all view states
abstract class ViewState extends Equatable {
  void dispose();

  ProcessState get state;

  String? get errorMessage;

  bool get isLoading => state == ProcessState.loading;

  bool get hasError => state == ProcessState.error;

  bool get isSuccess => state == ProcessState.success;

  bool get hasData;

  bool get isEmpty;
}
