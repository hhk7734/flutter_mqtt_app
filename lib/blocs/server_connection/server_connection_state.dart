part of 'server_connection_bloc.dart';

abstract class ServerConnectionState extends Equatable {
  const ServerConnectionState();
}

class ServerConnectionInitial extends ServerConnectionState {
  @override
  List<Object> get props => [];
}
