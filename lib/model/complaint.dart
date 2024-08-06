import 'dart:convert';

import '../enum/ranking_list_type.dart';

class ComplaintModel{
  final int id;
  final String reason;
  final RankingListType type;
  final int status;

  const ComplaintModel({
    this.id = 0,
    required this.reason,
    this.type = RankingListType.MESSAGE,
    this.status = 1
  });

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
        id: map['id'] as int? ?? 0,
        reason: map['reason'] as String? ?? '',
        type: RankingListType.values[map['type'] as int? ?? 0],
        status: map['status'] as int? ?? 0
    );
  }

  factory ComplaintModel.fromJson(String source) => ComplaintModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ComplaintModel copyWith({
    int? id,
    String? reason,
    RankingListType? type,
    int? status
  }){
    return ComplaintModel(
        id: id ?? this.id,
        reason: reason ?? this.reason,
        type: type ?? this.type,
        status: status ?? this.status
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'reason': reason,
      'type': type.name,
      'status': status
    };
  }

  Map<String, dynamic> addComplaint(){
    return {
      'reason': reason,
      'status': status
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is ComplaintModel &&
    other.id == id &&
    other.reason == reason &&
    other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    reason.hashCode ^
    status.hashCode;
  }
}