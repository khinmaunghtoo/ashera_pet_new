class AddMemberFeedbackDTO{
  final int memberId;
  final String body;

  const AddMemberFeedbackDTO({
    required this.memberId,
    required this.body
  });

  factory AddMemberFeedbackDTO.fromMap(Map<String, dynamic> map){
    return AddMemberFeedbackDTO(
        memberId: map['memberId'] as int? ?? 0,
        body: map['body'] as String? ?? ''
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'memberId': memberId,
      'body': body
    };
  }
}