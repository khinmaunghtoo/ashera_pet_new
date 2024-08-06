import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class TermsAndForgetPassword extends StatefulWidget{
  final bool isAgreedTerms;
  final ValueChanged<bool?>? onChange;
  final VoidCallback forgetClick;
  final VoidCallback termsClick;
  final bool isShowForgetPassword;

  const TermsAndForgetPassword({
    super.key,
    required this.isAgreedTerms,
    required this.onChange,
    required this.forgetClick,
    required this.termsClick,
    this.isShowForgetPassword = true
  });

  @override
  State<StatefulWidget> createState() => _TermsAndForgetPasswordState();
}

class _TermsAndForgetPasswordState extends State<TermsAndForgetPassword>{

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //同意用戶條款
        SizedBox(
          height: 30,
          child: _termsWidget(),
        ),
        //忘記密碼
        if(widget.isShowForgetPassword)
        _forgetPasswordWidget()
      ],
    );
  }
  //條款
  Widget _termsWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 30,
          child: Checkbox(
            fillColor: WidgetStateProperty.resolveWith(getColor),
            value: widget.isAgreedTerms,
            onChanged: widget.onChange,
          ),
        ),
        GestureDetector(
          onTap: widget.termsClick,
          child: const Text(
            '同意用戶約定條款',
            style: TextStyle(
              color: AppColor.textFieldHintText,
            ),
          ),
        )
      ],
    );
  }

  //忘記密碼
  Widget _forgetPasswordWidget(){
    return GestureDetector(
      onTap: widget.forgetClick,
      child: const Text(
        '忘記密碼?',
        style: TextStyle(
            color: AppColor.button
        ),
      ),
    );
  }

  Color getColor(Set<WidgetState> states) {
    if (widget.isAgreedTerms) {
      return AppColor.button;
    } else {
      return AppColor.button;
    }
  }


}