part of '../models.dart';

class Costs extends Equatable {
  final String? service;
  final String? description;
  final List<Cost>? cost;

  const Costs({this.service, this.description, this.cost});

  factory Costs.fromMap(Map<String, dynamic> data) => Costs(
        service: data['service'] as String?,
        description: data['description'] as String?,
        cost: (data['cost'] as List<dynamic>?)
            ?.map((e) => Cost.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'service': service,
        'description': description,
        'cost': cost?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Costs].
  factory Costs.fromJson(String data) {
    return Costs.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Costs] to a JSON string.
  String toJson() => json.encode(toMap());

  Costs copyWith({
    String? service,
    String? description,
    List<Cost>? cost,
  }) {
    return Costs(
      service: service ?? this.service,
      description: description ?? this.description,
      cost: cost ?? this.cost,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [service, description, cost];
}
