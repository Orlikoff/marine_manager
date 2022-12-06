import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:marine_manager/credentials.dart';
import 'package:marine_manager/data/repositories/marine_repo.dart';

part 'account_data_state.dart';

class AccountDataCubit extends Cubit<AccountDataState> {
  final MarineRepo marineRepo;

  AccountDataCubit(this.marineRepo) : super(AccountDataInitial());

  void authUser(String email, String password,
      {VoidCallback? onWrongCreds}) async {
    emit(AccountDataLoading());
    var data = await marineRepo.authenticateUser(
      email,
      password,
      onWrongCreds: onWrongCreds,
    );

    if (data != null) {
      credentials = data;
      emit(AccountDataChanged(data));
    }
  }
}
