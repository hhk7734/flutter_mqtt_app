part of 'remote_control_bloc.dart';

abstract class RemoteControlState extends Equatable {
  const RemoteControlState();
}

class RemoteControlInitial extends RemoteControlState {
  @override
  List<Object> get props => [];
}

class RemoteControlValueUpdateSuccess extends RemoteControlState {
  final List<dynamic> values;

  const RemoteControlValueUpdateSuccess({this.values});

  @override
  List<Object> get props => [values];
}
