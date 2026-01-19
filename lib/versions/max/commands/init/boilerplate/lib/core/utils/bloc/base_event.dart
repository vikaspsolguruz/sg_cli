import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  const BaseEvent();

  Map<String, dynamic> getAnalyticParameters();

  @override
  List<Object?> get props => [];
}