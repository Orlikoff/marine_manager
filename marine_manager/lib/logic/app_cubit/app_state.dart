part of 'app_cubit.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppLogin extends AppState {}

class AppRegister extends AppState {}

class AppLogged extends AppState {}
