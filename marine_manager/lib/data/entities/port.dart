import 'package:equatable/equatable.dart';

class PortData extends Equatable {
  final dynamic id;
  final dynamic marineWorkerId;
  final dynamic portName;
  final dynamic portUnifiedCode;
  final dynamic portCountry;
  final dynamic maxContainersCapacity;
  PortData({
    required this.id,
    required this.marineWorkerId,
    required this.portName,
    required this.portUnifiedCode,
    required this.portCountry,
    required this.maxContainersCapacity,
  });

  @override
  List<Object?> get props => [portUnifiedCode];
}
