import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/remote_control/remote_control_bloc.dart';

import '../../repositories/mqtt/mqtt_repository.dart';

class RemoteControlScreen extends StatelessWidget {
  static const String id = 'remote_control';
  final MqttRepository _mqttRepository;

  RemoteControlScreen({MqttRepository mqttRepository})
      : _mqttRepository = mqttRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemoteControlBloc(
        mqttRepository: _mqttRepository,
      ),
      child: WillPopScope(
        onWillPop: () {
          print('RemoteControlScreen: onWillPop');
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'ODROID-C4 + Flutter + Mqtt',
              style: TextStyle(
                color: Colors.indigo,
              ),
            ),
            backgroundColor: Colors.lime[200],
          ),
          body: BlocBuilder<RemoteControlBloc, RemoteControlState>(
            builder: (context, state) {
              if (state is RemoteControlValueUpdateSuccess) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.values.length,
                    (index) => ControlWidget(
                      index: index,
                      state: state,
                    ),
                  ),
                );
              } else if (state is RemoteControlUnsolicitedlyDisconnectSuccess) {
                Future.delayed(Duration(seconds: 2))
                    .then((value) => Navigator.of(context).pop());
                return Center(child: Text('Unsolicitedly Disconnected.'));
              } else {
                BlocProvider.of<RemoteControlBloc>(context)
                    .add(RemoteControlValueGeted(topic: 'get'));
                return Center(child: Text('Initial'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class ControlWidget extends StatefulWidget {
  final int index;
  final RemoteControlValueUpdateSuccess state;

  ControlWidget({
    this.index,
    this.state,
  });

  @override
  _ControlWidgetState createState() => _ControlWidgetState();
}

class _ControlWidgetState extends State<ControlWidget> {
  @override
  Widget build(BuildContext context) {
    Color color =
        widget.state.values[widget.index] ? Colors.red[200] : Colors.grey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 1, 3, 0),
          child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              )),
        ),
        RaisedButton(
          child: Text('Toggle'),
          onPressed: () {
            setState(
              () {
                BlocProvider.of<RemoteControlBloc>(context).add(
                  RemoteControlValueSeted(
                      currentValues: widget.state.values,
                      index: widget.index,
                      nextValue: widget.state.values[widget.index] ^= true),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
