import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'remote_control_event.dart';
part 'remote_control_state.dart';

class RemoteControlBloc extends Bloc<RemoteControlEvent, RemoteControlState> {
  @override
  RemoteControlState get initialState => RemoteControlInitial();

  @override
  Stream<RemoteControlState> mapEventToState(
    RemoteControlEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
