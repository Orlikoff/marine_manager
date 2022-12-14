part of 'route_data_cubit.dart';

abstract class RouteDataState extends Equatable {}

class RouteDataInitial extends RouteDataState {
  @override
  List<Object?> get props => [1];
}

class RouteDataLoading extends RouteDataState {
  @override
  List<Object?> get props => [1];
}

class RouteDataChanged extends RouteDataState {
  final List<dynamic> data;

  RouteDataChanged(this.data);

  @override
  List<Object?> get props => [data.hashCode, data.length];
}
