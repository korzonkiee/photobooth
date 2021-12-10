import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'session_setup_event.dart';
part 'session_setup_state.dart';

class SessionSetupBloc extends Bloc<SessionSetupEvent, SessionSetupState> {
  SessionSetupBloc() : super(const SessionSetupState.initial());
}
