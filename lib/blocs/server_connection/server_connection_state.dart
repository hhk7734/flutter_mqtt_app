part of 'server_connection_bloc.dart';

abstract class ServerConnectionState extends Equatable {
  const ServerConnectionState();
}

class ServerConnectionInitial extends ServerConnectionState {
  @override
  List<Object> get props => [];
}

class ServerConnectionConnectInProgress extends ServerConnectionState {
  @override
  List<Object> get props => [];
}

class ServerConnectionConnectSuccess extends ServerConnectionState {
  @override
  List<Object> get props => [];
}

class ServerConnectionConnectFailure extends ServerConnectionState {
  @override
  List<Object> get props => [];
}
