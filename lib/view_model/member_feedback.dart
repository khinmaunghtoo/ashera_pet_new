import 'package:ashera_pet_new/model/tuple.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/material.dart';

import '../model/member_feedback.dart';

class MemberFeedbackVm with ChangeNotifier {
  Future<Tuple<bool, String>> addMemberFeedback(
      AddMemberFeedbackDTO dto) async {
    Tuple<bool, String> r = await Api.postMemberFeedback(dto.toMap());
    return r;
  }
}
