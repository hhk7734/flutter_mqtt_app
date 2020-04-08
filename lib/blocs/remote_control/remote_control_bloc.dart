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
    // TODO: implement mapEventToState
  }
}
