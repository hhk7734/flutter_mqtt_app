import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'server_connection_event.dart';
part 'server_connection_state.dart';

class ServerConnectionBloc
    extends Bloc<ServerConnectionEvent, ServerConnectionState> {
  @override
  ServerConnectionState get initialState => ServerConnectionInitial();

  @override
  Stream<ServerConnectionState> mapEventToState(
    ServerConnectionEvent event,
  ) async* {
    if (event is ServerConnectionConnected) {
      yield* _mapServerConnectionConnectedToState(event);
    }
  }

  Stream<ServerConnectionState> _mapServerConnectionConnectedToState(
      ServerConnectionConnected event) async* {
    yield ServerConnectionConnectSuccess();
    yield ServerConnectionConnectFailure();
    yield ServerConnectionConnectInProgress();
  }
}
