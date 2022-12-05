import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marine_manager/data/repositories/marine_repo.dart';
import 'package:meta/meta.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final MarineRepo marineRepo;

  DataCubit(this.marineRepo) : super(DataInitial());

  Future<void> loadData() async {
    if (state is DataLoading) return;
    emit(DataLoading());
    var data = await Future.delayed(const Duration(seconds: 2), () {
      return marineRepo.loadUsernames();
    });
    emit(DataChanged(data));
  }

  Future<void> changeUsername(int index, String newUsername) async {
    await marineRepo.changeUsername(index, newUsername);
    loadData();
  }
}
