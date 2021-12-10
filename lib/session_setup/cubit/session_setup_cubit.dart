import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'session_setup_state.dart';

class SessionSetupCubit extends Cubit<SessionSetupState> {
  SessionSetupCubit() : super(const SessionSetupState.initial());
}
