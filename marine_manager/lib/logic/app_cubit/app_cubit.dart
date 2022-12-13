import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_manager/credentials.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppRegister());

  void login() {
    emit(AppLogin());
    credentials = null;
  }

  void register() => emit(AppRegister());
  void logged() => emit(AppLogged());
}
