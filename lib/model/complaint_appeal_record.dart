import '../enum/adopt_status.dart';
import '../enum/ranking_list_type.dart';

class ComplaintAppealRecordModel{
  final int id;
  final int complaintRecordId;
  final int fromMemberId;
  final int targetMemberId;
  final String reply;
  final String replyPics;
  final String replyAt;
  final RankingListType type;
  final bool pass;
  final String passAt;
  final ComplaintRecordStatus status;

  const ComplaintAppealRecordModel({
    this.id = 0,
    this.complaintRecordId = 0,
    this.fromMemberId = 0,
    this.targetMemberId = 0,
    this.reply = '',
    this.replyPics = '',
    this.replyAt = '',
    this.type = RankingListType.MESSAGE,
    this.pass = false,
    this.passAt = '',
    this.status = ComplaintRecordStatus.WAITING_REPLY
  });

  Map<String, dynamic> addMap(){
    return {
      'complaintRecordId': complaintRecordId,
      'fromMemberId': fromMemberId,
      'targetMemberId': targetMemberId,
      'reply': reply,
      'replyPics': replyPics,
    };
  }
}