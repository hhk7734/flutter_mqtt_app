import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../../blocs/remote_control/remote_control_bloc.dart';

import '../../repositories/mqtt/mqtt_repository.dart';

class RemoteControlScreen extends StatefulWidget {
  static const String id = 'remote_control';
  final MqttRepository _mqttRepository;

  RemoteControlScreen({MqttRepository mqttRepository})
      : _mqttRepository = mqttRepository;

  @override
  _RemoteControlScreenState createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Control'),
      ),
      body: BlocProvider(
        create: (context) => RemoteControlBloc(
          mqttRepository: widget._mqttRepository,
        ),
        child: BlocBuilder<RemoteControlBloc, RemoteControlState>(
          builder: (context, state) {
            if (state is RemoteControlValueUpdateSuccess) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  state.values.length,
                  (index) {
                    return Text('${state.values[index]} ');
                  },
                ),
              );
            } else {
              return Text('Initial');
            }
          },
        ),
      ),
    );
  }
}
