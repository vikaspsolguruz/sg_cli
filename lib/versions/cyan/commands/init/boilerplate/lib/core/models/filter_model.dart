import 'package:equatable/equatable.dart';

abstract class FilterModel extends Equatable {
  const FilterModel();

  FilterModel clear();

  bool get hasFilters;

  int get filterCount;

  Map<String, dynamic> toJson();
}
