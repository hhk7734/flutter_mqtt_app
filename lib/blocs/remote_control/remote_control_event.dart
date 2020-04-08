part of 'remote_control_bloc.dart';

abstract class RemoteControlEvent extends Equatable {
  const RemoteControlEvent();
}

class RemoteControlValueUpdated extends RemoteControlEvent {
  final List<dynamic> values;

  const RemoteControlValueUpdated({this.values});

  @override
  List<Object> get props => [values];
}
