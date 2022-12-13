import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import '../../credentials.dart';
import '../../data/repositories/marine_repo.dart';

part 'account_data_state.dart';

class AccountDataCubit extends Cubit<AccountDataState> {
  final MarineRepo marineRepo;

  AccountDataCubit(this.marineRepo) : super(AccountDataInitial());

  Future<void> authUser(String email, String password,
      {VoidCallback? onWrongCreds, VoidCallback? onSuccess}) async {
    emit(AccountDataLoading());
    var data = await marineRepo.authenticateUser(
      email,
      password,
      onWrongCreds: onWrongCreds,
    );

    if (data != null) {
      if (onSuccess != null) onSuccess();
      credentials = data;
      emit(AccountDataChanged(data));
    }
  }

  void changePassword(String newPassword) {
    marineRepo.changePassword(newPassword);
    credentials!['user_password'] = newPassword;
  }

  Future<void> upgradeToWorker(String company, String country) async {
    await marineRepo.upgradeToWorker(company, country);
    await authUser(credentials!['user_email'], credentials!['user_password']);
    emit(AccountDataChanged(credentials!));
  }
}
