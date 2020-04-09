import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttRepository {
  final MqttServerClient client;
  final Map<String, Completer<bool>> _subscriptionState =
      Map<String, Completer<bool>>();
  final Map<String, Stream<String>> _subscriptionStream =
      Map<String, Stream<String>>();
  final Map<String, DisconnectCallback> unsolicitedlyDisconnectCallback =
      Map<String, DisconnectCallback>();

  MqttRepository(
      {String server,
      String clientIdentifier,
      int port = MqttClientConstants.defaultMqttPort})
      : client = MqttServerClient.withPort(server, clientIdentifier, port) {
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;
    client.onSubscribeFail = _onSubscribeFail;
  }

  get mqttConnectionState => client.connectionStatus.state;

  get mqttConnectReturnCode => client.connectionStatus.returnCode;

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

  disconnect() => client.disconnect();

  Future<Stream<String>> subscribe(
      {String topic, MqttQos mqttQos = MqttQos.atMostOnce}) async {
    switch (mqttConnectionState) {
      case MqttConnectionState.connected:
        if (!_subscriptionStream.containsKey(topic)) {
          client.subscribe(topic, mqttQos);
          _subscriptionState.putIfAbsent(topic, () => Completer.sync());
          bool isSuccess = await _subscriptionState[topic].future;
          _subscriptionState.remove(topic);

          if (isSuccess) {
            Stream<String> stream = MqttClientTopicFilter(topic, client.updates)
                .updates
                .transform<String>(StreamTransformer<
                    List<MqttReceivedMessage<MqttMessage>>,
                    String>.fromHandlers(
                  handleData: (data, sink) {
                    final MqttPublishMessage recMess = data[0].payload;
                    final pt = MqttPublishPayload.bytesToStringAsString(
                        recMess.payload.message);
                    sink.add(pt);
                  },
                  handleError: (error, stackTrace, sink) =>
                      sink.addError(error, stackTrace),
                  handleDone: (sink) => sink.close(),
                ))
                .asBroadcastStream();

            _subscriptionStream.putIfAbsent(topic, () => stream);
          } else {
            return null;
          }
        }

        return _subscriptionStream[topic];
        break;
      default:
        return null;
        break;
    }
  }

  bool publish(
      {String topic, String payload, MqttQos mqttQos = MqttQos.atMostOnce}) {
    switch (mqttConnectionState) {
      case MqttConnectionState.connected:
        final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
        builder.addString(payload);
        client.publishMessage(topic, mqttQos, builder.payload);
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  set attachOnSubscribed(SubscribeCallback callback) {
    client.onSubscribed = (String topic) {
      _onSubscribed(topic);
      callback(topic);
    };
  }

  set attachOnSubscribeFail(SubscribeCallback callback) {
    client.onSubscribed = (String topic) {
      _onSubscribeFail(topic);
      callback(topic);
    };
  }

  _onConnected() {
    print('MqttRepository: connected');
  }

  _onDisconnected() {
    print('MqttRepository: disconnected: $mqttConnectReturnCode');
    _subscriptionStream.clear();
    switch (mqttConnectReturnCode) {
      case MqttConnectReturnCode.unsolicited:
        unsolicitedlyDisconnectCallback.forEach(
          (key, callback) {
            callback();
          },
        );
        break;
      default:
        break;
    }
  }

  _onSubscribed(String topic) {
    print('MqttRepository: subscribed: topic: $topic');
    _subscriptionState[topic].complete(true);
  }

  _onSubscribeFail(String topic) {
    print('MqttRepository: subscribeFail: topic: $topic');
    _subscriptionState[topic].complete(false);
  }
}
