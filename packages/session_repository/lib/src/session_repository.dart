import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
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

  /// A list of cached session strams by session id.
  final _cachedSessions = <String, BehaviorSubscription<Session>>{};

  /// Returns a [Stream] of the [Session] with the given [id].
  ValueStream<Session> getSession(String id) {
    final cachedSubscription = _cachedSessions[id];
    if (cachedSubscription != null) {
      return cachedSubscription.stream;
    }

    final sub = BehaviorSubscription<Session>.fromStream(
      _firebaseFirestore
          .collection('sessions')
          .doc(id)
          .snapshots()
          .map((d) => d.data()!)
          .map((json) => Session.fromJson(json)),
    );

    _cachedSessions[id] = sub;
    return sub.stream;
  }

  /// Returns the list of downloadable image URLs for the given list of Firebase
  /// Storage URLs.
  Future<List<String>> getDownloadUrls(List<String> urls) {
    return Future.wait(
      [
        for (final url in urls)
          _firebaseStorage.ref().child(url).getDownloadURL(),
      ],
    );
  }

  /// Uploads the provided [photo] to Firebase Storage and then sets the photo
  /// URLs on the session with the given [sessionId].
  ///
  /// Currently does nothing.
  Future<void> uploadSessionPhoto({
    required String sessionId,
    required Uint8List photo,
  }) {
    // 1. Upload to Firebase Storage
    // 2. Get the URLs
    // 3. Run an update-array transaction on the session with the given ID.
    return Future<void>.delayed(const Duration(seconds: 1));
  }
}

class BehaviorSubscription<T> {
  const BehaviorSubscription._(
    this._subject,
    this._subscription,
  );

  factory BehaviorSubscription.fromStream(
    Stream<T> stream,
  ) {
    final subject = BehaviorSubject<T>();
    return BehaviorSubscription._(subject, stream.listen(subject.add));
  }

  final BehaviorSubject<T> _subject;
  final StreamSubscription<T> _subscription;

  ValueStream<T> get stream => _subject.stream;

  void cancel() {
    _subscription.cancel();
    _subject.close();
  }
}
