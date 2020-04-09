import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../repositories/mqtt/mqtt_repository.dart';

part 'remote_control_event.dart';
part 'remote_control_state.dart';

class RemoteControlBloc extends Bloc<RemoteControlEvent, RemoteControlState> {
  final MqttRepository _mqttRepository;

  RemoteControlBloc({@required MqttRepository mqttRepository})
      : _mqttRepository = mqttRepository {
    _mqttRepository.unsolicitedlyDisconnectCallback.putIfAbsent(
      'remoteControlBloc',
      () => () {
        add(RemoteControlUnsolicitedlyDisconnected());
      },
    );
  }

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
    } else if (event is RemoteControlValueGeted) {
      yield* _mapRemoteControlValueGetedToState(event);
    } else if (event is RemoteControlUnsolicitedlyDisconnected) {
      yield* _mapRemoteControlUnsolicitedlyDisconnectedToState();
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

  Stream<RemoteControlState> _mapRemoteControlValueGetedToState(
      RemoteControlValueGeted event) async* {
    _mqttRepository.subscribe(topic: event.topic).then(
      (stream) {
        stream.listen(
          (values) {
            add(RemoteControlValueUpdated(values: jsonDecode(values)));
          },
        );
      },
    );
  }

  Stream<RemoteControlState>
      _mapRemoteControlUnsolicitedlyDisconnectedToState() async* {
    yield RemoteControlUnsolicitedlyDisconnectSuccess();
  }

  @override
  Future<void> close() {
    _mqttRepository.unsolicitedlyDisconnectCallback.remove('remoteControlBloc');
    return super.close();
  }
}
