import 'package:flutter/material.dart';

import 'repositories/mqtt/mqtt_repository.dart';

import 'screens/remote_control/remote_control_screen.dart';
import 'screens/server_connection/server_connection_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MqttRepository mqttRepository = MqttRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ServerConnectionScreen.id,
      routes: {
        ServerConnectionScreen.id: (context) => ServerConnectionScreen(
              mqttRepository: mqttRepository,
            ),
        RemoteControlScreen.id: (context) => RemoteControlScreen(
              mqttRepository: mqttRepository,
            ),
      },
    );
  }
}
