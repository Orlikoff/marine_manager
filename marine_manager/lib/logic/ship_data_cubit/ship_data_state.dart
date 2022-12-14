part of 'ship_data_cubit.dart';

@immutable
abstract class ShipDataState extends Equatable {}

class ShipDataInitial extends ShipDataState {
  @override
  List<Object?> get props => [1];
}

class ShipDataLoading extends ShipDataState {
  @override
  List<Object?> get props => [1];
}

class ShipDataChanged extends ShipDataState {
  final List<dynamic> data;

  ShipDataChanged(this.data);

  @override
  List<Object?> get props => [data.hashCode, data.length];
}
