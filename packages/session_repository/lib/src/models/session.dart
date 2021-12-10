import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:session_repository/src/converters/converters.dart';

part 'session.g.dart';

/// {@template session}
/// The model for a group photobooth session.
///
/// Represented in Firestore in the `/sessions` collection.
/// {@endtemplate}
@JsonSerializable()
class Session extends Equatable {
  /// {@macro session}
  const Session({
    required this.id,
    required this.createdAt,
    required this.prompt,
    required this.photoUrls,
  });

  /// Deserializes a [Session] from a JSON object.
  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  /// The session's unique identifier.
  ///
  /// This is the ID of the document in Firestore.
  final String id;

  /// The date and time the session was created.
  @TimestampConverter()
  final DateTime createdAt;

  /// The prompt for the session.
  ///
  /// This is the question shown to the user when taking a picture.
  final String prompt;

  /// The URLs of the photos taken during the session.
  ///
  /// This is the list of Firebase Storage URLs of the photos taken during the
  /// session.
  final List<String> photoUrls;

  /// Serializes a [Session] to a JSON object.
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  List<Object?> get props => [id, createdAt, prompt, photoUrls];
}
