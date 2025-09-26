import 'package:example/app_routes/route_names.dart';
import 'package:example/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:example/pages/sign_in/view/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  Routes.signIn: (context) => BlocProvider<SignInBloc>(
        create: (context) => SignInBloc(),
        lazy: false,
        child: const SignInPage(),
      ),
};
