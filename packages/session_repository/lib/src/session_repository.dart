import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:session_repository/session_repository.dart';

/// {@template session_repository}
/// Repository that manages sessions.
/// {@endtemplate
class SessionRepository {
  /// {@macro session_repository}
  SessionRepository({
    required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseStorage = firebaseStorage,
        _firebaseFirestore = firebaseFirestore;

  // ignore: unused_field
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  /// Returns a [Stream] of the [Session] with the given [id].
  Stream<Session> getSession(String id) {
    return _firebaseFirestore
        .collection('sessions')
        .doc(id)
        .snapshots()
        .map((d) => d.data()!)
        .map((json) => Session.fromJson(json));
  }
}
