import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

part 'session_sharing_state.dart';

class SessionSharingCubit extends Cubit<SessionSharingState> {
  SessionSharingCubit({
    // TODO(alejandro): USE sessionRepository
    // ignore: avoid_unused_constructor_parameters
    required SessionRepository sessionRepository,
  }) : super(const SessionSharingState.initial());
}
