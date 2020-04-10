part of 'server_connection_bloc.dart';

abstract class ServerConnectionEvent extends Equatable {
  const ServerConnectionEvent();
}

class ServerConnectionConnected extends ServerConnectionEvent {
  final String server;
  final ServerConnectionConnectedNextState state;

  const ServerConnectionConnected({
    @required this.server,
    this.state = ServerConnectionConnectedNextState.inProgress,
  });

  @override
  List<Object> get props => [server, state];
}
