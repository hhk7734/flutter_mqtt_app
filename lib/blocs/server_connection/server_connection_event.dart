part of 'server_connection_bloc.dart';

abstract class ServerConnectionEvent extends Equatable {
  const ServerConnectionEvent();
}

class ServerConnectionConnected extends ServerConnectionEvent {
  final String server;
  final String clientIdentifier;
  final ServerConnectionConnectedNextState state;

  const ServerConnectionConnected({
    this.server,
    this.clientIdentifier,
    this.state = ServerConnectionConnectedNextState.inProgress,
  });

  @override
  List<Object> get props => [server, clientIdentifier, state];
}

class ServerConnectionDisconnected extends ServerConnectionEvent {
  @override
  List<Object> get props => [];
}
