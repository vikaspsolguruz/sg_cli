import 'package:equatable/equatable.dart';

abstract class BlocEvent extends Equatable {
  const BlocEvent();

  Map<String, dynamic> getAnalyticParameters();

  @override
  List<Object?> get props => [];
}