import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttRepository {
  final MqttServerClient client;

  MqttRepository(
      {String server,
      String clientIdentifier,
      int port = MqttClientConstants.defaultMqttPort})
      : client = MqttServerClient.withPort(server, clientIdentifier, port) {
    client.logging(on: false);
    client.keepAlivePeriod = 60;
  }
}
