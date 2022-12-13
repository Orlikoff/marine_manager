import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import '../../data/repositories/marine_repo.dart';
import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';

part 'container_data_state.dart';

class ContainerDataCubit extends Cubit<ContainerDataState> {
  final MarineRepo marineRepo;

  ContainerDataCubit(this.marineRepo) : super(ContainerDataInitial());

  Future<void> loadData() async {
    if (state is ContainerDataLoading) return;
    emit(ContainerDataLoading());
    var data = await Future.delayed(const Duration(seconds: 2), () {
      return marineRepo.loadUsernames();
    });
    emit(ContainerDataChanged(data));
  }

  Future<void> changeUsername(
    int index,
    String newUsername, {
    VoidCallback? onError,
  }) async {
    try {
      await marineRepo.changeUsername(index, newUsername);
      loadData();
    } catch (_) {
      if (onError != null) {
        onError();
      }
    }
  }
}
