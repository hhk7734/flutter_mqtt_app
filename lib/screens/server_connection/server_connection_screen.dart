import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/server_connection/server_connection_bloc.dart';
import '../../repositories/mqtt/mqtt_repository.dart';

import '../../screens/remote_control/remote_control_screen.dart';

class ServerConnectionScreen extends StatefulWidget {
  static const String id = 'server_connection';
  final MqttRepository _mqttRepository;

  ServerConnectionScreen({MqttRepository mqttRepository})
      : _mqttRepository = mqttRepository;

  @override
  _ServerConnectionScreenState createState() => _ServerConnectionScreenState();
}

class _ServerConnectionScreenState extends State<ServerConnectionScreen> {
  ServerConnectionBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = ServerConnectionBloc(mqttRepository: widget._mqttRepository);
    final _serverTextFieldController = TextEditingController();
    final _clientIdTextFieldController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sever connection'),
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocBuilder<ServerConnectionBloc, ServerConnectionState>(
          condition: (previous, current) {
            if (current is ServerConnectionConnectInProgress) {
              return false;
            } else if (current is ServerConnectionConnectSuccess) {
              Navigator.of(context).pushNamed(RemoteControlScreen.id).then(
                (value) {
                  _bloc.add(ServerConnectionDisconnected());
                },
              );
              return false;
            } else if (current is ServerConnectionConnectFailure) {
              return false;
            } else {
              return true;
            }
          },
          builder: (context, state) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(4),
                      child: Row(children: <Widget>[
                        Flexible(
                            child: TextField(
                          controller: _serverTextFieldController,
                          decoration: new InputDecoration.collapsed(
                              hintText: "Enter your MQTT server address"),
                        )),
                      ])),
                  Container(
                      margin: EdgeInsets.all(4),
                      child: Row(children: <Widget>[
                        Flexible(
                            child: TextField(
                          controller: _clientIdTextFieldController,
                          decoration: new InputDecoration.collapsed(
                              hintText: "Enter your client identifier (Optional)"),
                        )),
                      ])),
                  Container(
                      margin: EdgeInsets.all(4),
                      child: RaisedButton(
                          child: Text('OK'),
                          onPressed: () {
                            _bloc.add(ServerConnectionConnected(
                                server: _serverTextFieldController.text.trim(),
                                clientIdentifier: _clientIdTextFieldController
                                        .text.trim().isNotEmpty
                                    ? _clientIdTextFieldController.text.trim()
                                    : 'flutter${Random.secure().nextInt(1000)}'));
                          }))
                ]);
          },
        ),
      ),
    );
  }
}
