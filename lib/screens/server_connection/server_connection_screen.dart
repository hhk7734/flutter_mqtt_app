import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/server_connection/server_connection_bloc.dart';
import '../../repositories/mqtt/mqtt_repository.dart';

class ServerConnectionScreen extends StatefulWidget {
  static const String id = 'server_connection';
  final MqttRepository _mqttRepository;

  ServerConnectionScreen({MqttRepository mqttRepository})
      : _mqttRepository = mqttRepository;

  @override
  _ServerConnectionScreenState createState() => _ServerConnectionScreenState();
}

class _ServerConnectionScreenState extends State<ServerConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sever connection'),
      ),
      body: BlocProvider(
        create: (context) =>
            ServerConnectionBloc(mqttRepository: widget._mqttRepository),
        child: BlocBuilder<ServerConnectionBloc, ServerConnectionState>(
          builder: (context, state) {
            print(state);
            if (state is ServerConnectionConnectInProgress) {
              return Text('InProgress');
            } else if (state is ServerConnectionConnectSuccess) {
              return Text('Success');
            } else if (state is ServerConnectionConnectFailure) {
              return Text('Failure');
            } else {
              return Text('Initial');
            }
          },
        ),
      ),
    );
  }
}
