import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'route_data_state.dart';

class RouteDataCubit extends Cubit<RouteDataState> {
  RouteDataCubit() : super(RouteDataInitial());
}
