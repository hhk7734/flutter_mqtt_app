part of 'server_connection_bloc.dart';

abstract class ServerConnectionEvent extends Equatable {
  const ServerConnectionEvent();
}

class ServerConnectionConnected extends ServerConnectionEvent {
  final String server;

  const ServerConnectionConnected({@required this.server});

  @override
  List<Object> get props => [server];
}
