part of 'container_data_cubit.dart';

@immutable
abstract class ContainerDataState extends Equatable {}

class ContainerDataInitial extends ContainerDataState {
  @override
  List<Object?> get props => [1];
}

class ContainerDataLoading extends ContainerDataState {
  @override
  List<Object?> get props => [1];
}

class ContainerDataChanged extends ContainerDataState {
  final List<dynamic> data;

  ContainerDataChanged(this.data);

  @override
  List<Object?> get props => [data.hashCode, data.length];
}
