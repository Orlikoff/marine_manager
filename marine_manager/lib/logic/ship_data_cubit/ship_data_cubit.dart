import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/abstractions/data_provider.dart';
import '../../data/entities/route.dart';
import 'package:meta/meta.dart';

import '../../data/repositories/marine_repo.dart';

part 'ship_data_state.dart';

class ShipDataCubit extends Cubit<ShipDataState> {
  final MarineRepo marineRepo;

  ShipDataCubit(this.marineRepo) : super(ShipDataInitial());

  Future<void> createShip({
    required dynamic routeId,
    required dynamic vesselVerboseName,
    required dynamic countryOfOrigin,
    required dynamic maxLoadCapacity,
  }) async {
    await marineRepo.createShip(
      routeId: routeId,
      vesselVerboseName: vesselVerboseName,
      countryOfOrigin: countryOfOrigin,
      maxLoadCapacity: maxLoadCapacity,
    );
    var data = await marineRepo.loadShips();
    emit(ShipDataChanged(data));
  }

  Future<void> loadShip() async {
    if (state is ShipDataLoading) return;
    emit(ShipDataLoading());
    var data = await marineRepo.loadShips();
    emit(ShipDataChanged(data));
  }

  Future<void> removeShip(dynamic id) async {
    await marineRepo.removeShip(id);
    var data = await marineRepo.loadShips();
    emit(ShipDataChanged(data));
  }

  Future<List<RouteData>> loadRoute() async {
    return await marineRepo.loadRoutes();
  }
}
