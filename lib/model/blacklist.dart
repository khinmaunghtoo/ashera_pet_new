import 'dart:convert';

class BlackListModel{
  final int id;
  final int fromMemberId;
  final int targetMemberId;
  
  const BlackListModel({
    this.id = 0,
    required this.fromMemberId,
    required this.targetMemberId
  });
  
  factory BlackListModel.fromMap(Map<String, dynamic> map){
    return BlackListModel(
        id: map['id'] as int? ?? 0,
        fromMemberId: map['fromMemberId'] as int? ?? 0,
        targetMemberId: map['targetMemberId'] as int? ?? 0,
    );
  }
  
  factory BlackListModel.fromJson(String source) => BlackListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  BlackListModel copyWith({
    int? id,
    int? fromMemberId,
    int? targetMemberId
  }){
    return BlackListModel(
        id: id ?? this.id,
        fromMemberId: fromMemberId ?? this.fromMemberId,
        targetMemberId: targetMemberId ?? this.targetMemberId
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'fromMemberId': fromMemberId,
      'targetMemberId': targetMemberId
    };
  }

  Map<String, dynamic> addBlackList(){
    return {
      'fromMemberId': fromMemberId,
      'targetMemberId': targetMemberId
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;

    return other is BlackListModel &&
      other.id == id &&
      other.fromMemberId == fromMemberId &&
      other.targetMemberId == targetMemberId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    fromMemberId.hashCode ^
    targetMemberId.hashCode;
  }
}