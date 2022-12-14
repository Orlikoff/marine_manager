import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import '../../data/entities/port.dart';
import '../../data/entities/vessel.dart';
import '../../data/repositories/marine_repo.dart';
import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';

part 'container_data_state.dart';

class ContainerDataCubit extends Cubit<ContainerDataState> {
  final MarineRepo marineRepo;

  ContainerDataCubit(this.marineRepo) : super(ContainerDataInitial());

  Future<void> loadDataContainer() async {
    if (state is ContainerDataLoading) return;
    emit(ContainerDataLoading());
    var data = await marineRepo.loadContainers();
    emit(ContainerDataChanged(data));
  }

  Future<void> removeContainer(dynamic id) async {
    await marineRepo.removeContainer(id);
    var data = await marineRepo.loadContainers();
    emit(ContainerDataChanged(data));
  }

  Future<List<VesselData>> getVesselList() async {
    return await marineRepo.loadShips();
  }

  Future<List<PortData>> getPortList() async {
    return await marineRepo.loadPorts();
  }

  Future<void> createContainer({
    required dynamic dispPortId,
    required dynamic destPortId,
    required dynamic vesselId,
    required dynamic code,
  }) async {
    await marineRepo.createContainer(
      dispPortId: dispPortId,
      destPortId: destPortId == 'null' ? null : destPortId,
      vesselId: vesselId == 'null' ? null : vesselId,
      code: code,
    );
    await loadDataContainer();
  }
}
