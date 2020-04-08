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

  get mqttConnectionState => client.connectionStatus.state;

  Future<bool> connect() async {
    assert(client.server != null);
    assert(client.clientIdentifier != null);

    switch (mqttConnectionState) {
      case MqttConnectionState.disconnected:
        try {
          await client?.connect();
        } on Exception catch (e) {
          print('MqttRepository: connect: exception - $e');
          client.disconnect();
        }
        break;
    }

    switch (mqttConnectionState) {
      case MqttConnectionState.connected:
        return true;
      default:
        return false;
    }
  }
}
