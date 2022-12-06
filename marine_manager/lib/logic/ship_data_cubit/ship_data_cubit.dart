import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ship_data_state.dart';

class ShipDataCubit extends Cubit<ShipDataState> {
  ShipDataCubit() : super(ShipDataInitial());
}
