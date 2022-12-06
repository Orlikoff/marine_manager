import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'port_data_state.dart';

class PortDataCubit extends Cubit<PortDataState> {
  PortDataCubit() : super(DataInitial());
}
