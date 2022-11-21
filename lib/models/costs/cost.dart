part of '../models.dart';

class Cost extends Equatable {
  final int? value;
  final String? etd;
  final String? note;

  const Cost({this.value, this.etd, this.note});

  factory Cost.fromMap(Map<String, dynamic> data) => Cost(
        value: data['value'] as int?,
        etd: data['etd'] as String?,
        note: data['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'value': value,
        'etd': etd,
        'note': note,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Cost].
  factory Cost.fromJson(String data) {
    return Cost.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Cost] to a JSON string.
  String toJson() => json.encode(toMap());

  Cost copyWith({
    int? value,
    String? etd,
    String? note,
  }) {
    return Cost(
      value: value ?? this.value,
      etd: etd ?? this.etd,
      note: note ?? this.note,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [value, etd, note];
}
