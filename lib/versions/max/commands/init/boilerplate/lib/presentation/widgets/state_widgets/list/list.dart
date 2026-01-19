/// List State Widgets Library
///
/// Import this file to access all list-related state widgets.
/// Use: import 'package:max_arch/presentation/widgets/state_widgets/list/list.dart';
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_arch/core/constants/app_strings.dart';
import 'package:max_arch/core/enums/process_state.dart';
import 'package:max_arch/core/models/filter_model.dart';
import 'package:max_arch/core/models/view_states/list_state.dart';
import 'package:max_arch/core/models/view_states/list_state_with_filter.dart';
import 'package:max_arch/core/utils/console_print.dart';
import 'package:max_arch/presentation/widgets/empty_view.dart';
import 'package:max_arch/presentation/widgets/error_view.dart';
import 'package:max_arch/presentation/widgets/loader.dart';
import 'package:sliver_tools/sliver_tools.dart';

part 'sliver_list_state_widget.dart';
part 'sliver_list_state_with_filter_widget.dart';
