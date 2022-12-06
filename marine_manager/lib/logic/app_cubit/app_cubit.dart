import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppLogin());

  void login() => emit(AppLogin());
  void register() => emit(AppRegister());
  void logged() => emit(AppLogged());
}
