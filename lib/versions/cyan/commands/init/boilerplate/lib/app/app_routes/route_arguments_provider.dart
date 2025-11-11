import 'package:newarch/app/app_routes/route_arguments.dart';

class RouteArgumentsProvider {
  RouteArgumentsProvider._();

  static RouteArguments? _currentArguments;

  static void set(RouteArguments? arguments) {
    _currentArguments = arguments;
  }

  static T? get<T extends RouteArguments>() {
    if (_currentArguments is T) {
      return _currentArguments as T;
    }
    return null;
  }

  static void clear() {
    _currentArguments = null;
  }
}
