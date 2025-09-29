/// List State Widgets Library
///
/// Import this file to access all list-related state widgets.
/// Use: import 'package:newarch/presentation/widgets/state_widgets/list/list.dart';
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/enums/process_state.dart';
import 'package:newarch/core/models/filter_model.dart';
import 'package:newarch/core/models/view_states/list_state.dart';
import 'package:newarch/core/models/view_states/list_state_with_filter.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/presentation/widgets/empty_view.dart';
import 'package:newarch/presentation/widgets/error_view.dart';
import 'package:newarch/presentation/widgets/loader.dart';
import 'package:sliver_tools/sliver_tools.dart';

part 'sliver_list_state_widget.dart';
part 'sliver_list_state_with_filter_widget.dart';
