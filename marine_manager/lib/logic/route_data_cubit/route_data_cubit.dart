import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/entities/port.dart';
import '../../data/entities/route.dart';
import '../../data/repositories/marine_repo.dart';

part 'route_data_state.dart';

class RouteDataCubit extends Cubit<RouteDataState> {
  final MarineRepo marineRepo;
  RouteDataCubit(this.marineRepo) : super(RouteDataInitial());

  Future<void> removeRoute(dynamic id) async {
    await marineRepo.removeRoute(id);
    var data = await marineRepo.loadRoutes();
    emit(RouteDataChanged(data));
  }

  Future<void> loadRoutes() async {
    if (state is RouteDataLoading) return;
    emit(RouteDataLoading());
    var data = await marineRepo.loadRoutes();
    emit(RouteDataChanged(data));
  }

  Future<List<PortData>> loadPorts() async {
    return await marineRepo.loadPorts();
  }

  Future<void> createRoute({
    required dynamic shipmentCompany,
    required dynamic routeVesselCode,
    required List<PortData> portsLinked,
  }) async {
    dynamic id = await marineRepo.createRoute(
      shipmentCompany: shipmentCompany,
      routeVesselCode: routeVesselCode,
    );
    await marineRepo.createLinkedPorts(routeId: id, portsLinked: portsLinked);
    var data = await marineRepo.loadRoutes();
    emit(RouteDataChanged(data));
  }
}
