import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
    // TODO: implement mapEventToState
  }
}
