import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template timestamp_converter}
/// A timezone-aware [JsonConverter] which converts [DateTime] to/from [Timestamp].
/// {@endtemplate}
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  /// {@macro timestamp_converter}
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    final date = timestamp.toDate();
    return date.add(date.timeZoneOffset);
  }

  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date.subtract(date.timeZoneOffset));
  }
}
