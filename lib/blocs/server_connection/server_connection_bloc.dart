import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../repositories/mqtt/mqtt_repository.dart';

part 'server_connection_event.dart';
part 'server_connection_state.dart';

enum ServerConnectionConnectedNextState { inProgress, success, failure }

class ServerConnectionBloc
    extends Bloc<ServerConnectionEvent, ServerConnectionState> {
  final MqttRepository _mqttRepository;

  ServerConnectionBloc({@required MqttRepository mqttRepository})
      : _mqttRepository = mqttRepository {
    _mqttRepository.unsolicitedlyDisconnectCallback.putIfAbsent(
      'serverConnectionBloc',
      () => () {
        if (_mqttRepository.mqttConnectReturnCode ==
            MqttConnectReturnCode.unsolicited) {
          add(ServerConnectionUnsolicitedlyDisconnected());
        }
      },
    );
  }

  @override
  ServerConnectionState get initialState => ServerConnectionInitial();

  @override
  Stream<ServerConnectionState> mapEventToState(
    ServerConnectionEvent event,
  ) async* {
    if (event is ServerConnectionConnected) {
      yield* _mapServerConnectionConnectedToState(event);
    } else if (event is ServerConnectionUnsolicitedlyDisconnected) {
      yield* _mapServerConnectionUnsolicitedlyDisconnectedToState();
    }
  }

  Stream<ServerConnectionState> _mapServerConnectionConnectedToState(
      ServerConnectionConnected event) async* {
    switch (event.state) {
      case ServerConnectionConnectedNextState.inProgress:
        _mqttRepository.client.server = event.server;
        _mqttRepository.client.clientIdentifier = 'flutter';
        _mqttRepository.connect().then((value) {
          if (value) {
            add(ServerConnectionConnected(
                server: event.server,
                state: ServerConnectionConnectedNextState.success));
          } else {
            add(ServerConnectionConnected(
                server: event.server,
                state: ServerConnectionConnectedNextState.failure));
          }
        });
        yield ServerConnectionConnectInProgress();
        break;
      case ServerConnectionConnectedNextState.success:
        yield ServerConnectionConnectSuccess();
        break;
      default:
        yield ServerConnectionConnectFailure();
        break;
    }
  }

  Stream<ServerConnectionState>
      _mapServerConnectionUnsolicitedlyDisconnectedToState() async* {
    yield ServerConnectionUnsolicitedlyDisconnectSuccess();
  }

  @override
  Future<void> close() {
    _mqttRepository.unsolicitedlyDisconnectCallback
        .remove('serverConnectionBloc');
    return super.close();
  }
}
