part of 'remote_control_bloc.dart';

abstract class RemoteControlEvent extends Equatable {
  const RemoteControlEvent();
}

class RemoteControlValueUpdated extends RemoteControlEvent {
  final List<dynamic> values;

  const RemoteControlValueUpdated({@required this.values});

  @override
  List<Object> get props => [values];
}

class RemoteControlValueSeted extends RemoteControlEvent {
  final List<dynamic> currentValues;
  final int index;
  final dynamic nextValue;

  const RemoteControlValueSeted({
    @required this.currentValues,
    @required this.index,
    @required this.nextValue,
  });

  @override
  List<Object> get props => [currentValues, index, nextValue];
}

class RemoteControlValueGeted extends RemoteControlEvent {
  final String topic;

  const RemoteControlValueGeted({@required this.topic});

  @override
  List<Object> get props => [topic];
}

class RemoteControlUnsolicitedlyDisconnected extends RemoteControlEvent {
  @override
  List<Object> get props => [];
}
