import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../repositories/mqtt/mqtt_repository.dart';

part 'server_connection_event.dart';
part 'server_connection_state.dart';

enum ServerConnectionConnectedNextState { inProgress, success, failure }

class ServerConnectionBloc
    extends Bloc<ServerConnectionEvent, ServerConnectionState> {
  final MqttRepository _mqttRepository;

  ServerConnectionBloc({@required MqttRepository mqttRepository})
      : _mqttRepository = mqttRepository;

  @override
  ServerConnectionState get initialState => ServerConnectionInitial();

  @override
  Stream<ServerConnectionState> mapEventToState(
    ServerConnectionEvent event,
  ) async* {
    if (event is ServerConnectionConnected) {
      yield* _mapServerConnectionConnectedToState(event);
    } else if (event is ServerConnectionDisconnected) {
      yield* _mapServerConnectionDisconnectedToState();
    }
  }

  Stream<ServerConnectionState> _mapServerConnectionConnectedToState(
      ServerConnectionConnected event) async* {
    switch (event.state) {
      case ServerConnectionConnectedNextState.inProgress:
        assert(event.server != null);
        assert(event.clientIdentifier != null);

        _mqttRepository.client.server = event.server;
        _mqttRepository.client.clientIdentifier = event.clientIdentifier;
        _mqttRepository.connect().then((value) {
          if (value) {
            add(ServerConnectionConnected(
                state: ServerConnectionConnectedNextState.success));
          } else {
            add(ServerConnectionConnected(
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
      _mapServerConnectionDisconnectedToState() async* {
    _mqttRepository.disconnect();
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
