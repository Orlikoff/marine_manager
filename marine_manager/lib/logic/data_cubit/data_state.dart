part of 'data_cubit.dart';

@immutable
abstract class DataState extends Equatable {}

class DataInitial extends DataState {
  @override
  List<Object?> get props => [1];
}

class DataLoading extends DataState {
  @override
  List<Object?> get props => [1];
}

class DataChanged extends DataState {
  final List<dynamic> data;

  DataChanged(this.data);

  @override
  List<Object?> get props => [data.hashCode, data.length];
}
