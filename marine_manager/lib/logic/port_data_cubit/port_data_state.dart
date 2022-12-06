part of 'port_data_cubit.dart';

@immutable
abstract class PortDataState extends Equatable {}

class DataInitial extends PortDataState {
  @override
  List<Object?> get props => [1];
}

class DataLoading extends PortDataState {
  @override
  List<Object?> get props => [1];
}

class DataChanged extends PortDataState {
  final List<dynamic> data;

  DataChanged(this.data);

  @override
  List<Object?> get props => [data.hashCode, data.length];
}
