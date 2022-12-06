part of 'account_data_cubit.dart';

abstract class AccountDataState extends Equatable {}

class AccountDataInitial extends AccountDataState {
  @override
  List<Object?> get props => [1];
}

class AccountDataLoading extends AccountDataState {
  @override
  List<Object?> get props => [1];
}

class AccountDataChanged extends AccountDataState {
  final Map<String, dynamic> data;

  AccountDataChanged(this.data);

  @override
  List<Object?> get props => [data.hashCode, data.length];
}
