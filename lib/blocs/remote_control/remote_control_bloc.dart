import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../repositories/mqtt/mqtt_repository.dart';

part 'remote_control_event.dart';
part 'remote_control_state.dart';

class RemoteControlBloc extends Bloc<RemoteControlEvent, RemoteControlState> {
  final MqttRepository _mqttRepository;

  RemoteControlBloc({@required MqttRepository mqttRepository})
      : _mqttRepository = mqttRepository;

  @override
  RemoteControlState get initialState => RemoteControlInitial();

  @override
  Stream<RemoteControlState> mapEventToState(
    RemoteControlEvent event,
  ) async* {
    if (event is RemoteControlValueUpdated) {
      yield* _mapRemoteControlValueUpdatedToState(event);
    } else if (event is RemoteControlValueSeted) {
      yield* _mapRemoteControlValueSetedToState(event);
    }
  }

  Stream<RemoteControlState> _mapRemoteControlValueUpdatedToState(
      RemoteControlValueUpdated event) async* {
    yield RemoteControlValueUpdateSuccess(values: event.values);
  }

  Stream<RemoteControlState> _mapRemoteControlValueSetedToState(
      RemoteControlValueSeted event) async* {
    _mqttRepository.publish(
      topic: 'set',
      payload: {event.index: event.nextValue}.toString(),
    );
  }
}
