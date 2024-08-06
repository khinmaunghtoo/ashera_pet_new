import 'package:ashera_pet_new/enum/animal.dart';
import 'package:ashera_pet_new/enum/gender.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:ashera_pet_new/widget/animal_type_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';

import '../data/member.dart';
import '../enum/health_status.dart';
import '../utils/utils.dart';
import 'custom_year_and_month_picker.dart';
import 'gender_picker.dart';
import 'health_status_picker.dart';

//組合 有title的
class CombinationTextField extends StatelessWidget {
  final String title;
  //副標題
  final String subheading;
  final bool isRequired;
  final Widget child;
  const CombinationTextField(
      {super.key,
      required this.title,
      this.subheading = '',
      required this.isRequired,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: _getRequired())),
            if (subheading.isNotEmpty)
              Text(
                subheading,
                style: const TextStyle(color: Colors.red),
              )
          ],
        ),
        child
      ],
    );
  }

  RichText _getRequired() {
    return RichText(
        text: TextSpan(
            style: const TextStyle(color: AppColor.textFieldTitle),
            text: title,
            children: [
          if (isRequired)
            const TextSpan(
                text: '*', style: TextStyle(color: AppColor.required))
        ]));
  }
}

//組合 驗證碼專用
class CombinationButtonTextField extends StatelessWidget {
  final String title;
  final bool isRequired;
  final Widget child;
  final Widget button;
  const CombinationButtonTextField(
      {super.key,
      required this.title,
      required this.isRequired,
      required this.child,
      required this.button});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: _getRequired()),
        Row(
          children: [Expanded(flex: 2, child: child), Expanded(child: button)],
        )
      ],
    );
  }

  RichText _getRequired() {
    return RichText(
        text: TextSpan(
            style: const TextStyle(color: AppColor.textFieldTitle),
            text: title,
            children: [
          if (isRequired)
            const TextSpan(
                text: '*', style: TextStyle(color: AppColor.required))
        ]));
  }
}

//暱稱輸入框
class NicknameTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const NicknameTextField(
      {super.key, required this.focusNode, required this.controller});

  @override
  State<StatefulWidget> createState() => _NicknameTextFieldState();
}

class _NicknameTextFieldState extends State<NicknameTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請輸入暱稱',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
    );
  }
}

//帳號輸入框
class AccountTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const AccountTextField(
      {super.key, required this.focusNode, required this.controller});
  @override
  State<StatefulWidget> createState() => _AccountTextFieldState();
}

class _AccountTextFieldState extends State<AccountTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請輸入手機號碼',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
    );
  }
}

//密碼輸入框
class PasswordTextField extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  const PasswordTextField(
      {super.key,
      required this.formKey,
      required this.focusNode,
      required this.controller,
      required this.hint});

  @override
  State<StatefulWidget> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        style: const TextStyle(color: AppColor.textFieldTitle),
        focusNode: widget.focusNode,
        decoration: InputDecoration(
            counterText: '',
            suffixIcon: Container(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                child: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.button,
                  size: 25,
                ),
                onTap: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              ),
            ),
            errorText: null,
            contentPadding: const EdgeInsets.all(5),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: AppColor.textFieldUnSelectBorder, width: 1),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.button, width: 1),
                borderRadius: BorderRadius.circular(15)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Utils.getTextFieldFillColor(widget.focusNode),
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        controller: widget.controller,
        obscureText: !_obscure,
        maxLength: 12,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]'))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          return value!.length < 6 ? '密碼不得小於六位數' : null;
        },
      ),
    );
  }
}

//再次確認密碼輸入框
class CheckPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const CheckPasswordTextField(
      {super.key, required this.focusNode, required this.controller});

  @override
  State<StatefulWidget> createState() => _CheckPasswordTextFieldState();
}

class _CheckPasswordTextFieldState extends State<CheckPasswordTextField> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          suffixIcon: Container(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              child: Icon(
                _obscure ? Icons.visibility : Icons.visibility_off,
                color: AppColor.button,
                size: 25,
              ),
              onTap: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
            ),
          ),
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請再次輸入密碼',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
      obscureText: !_obscure,
    );
  }
}

//手機輸入框
class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const PhoneTextField(
      {super.key, required this.focusNode, required this.controller});

  @override
  State<StatefulWidget> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請輸入手機號碼',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
    );
  }
}

//驗證碼輸入框
class VerificationCodeTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const VerificationCodeTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _VerificationCodeTextFieldState();
}

class _VerificationCodeTextFieldState extends State<VerificationCodeTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請輸入驗證碼',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
    );
  }
}

//性別輸入框
class GenderTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const GenderTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _GenderTextFieldState();
}

class _GenderTextFieldState extends State<GenderTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: _onTap,
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請選擇性別',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
    );
  }

  void _onTap() {
    showDialog(
        context: context,
        builder: (context) {
          return GenderPicker(
            success: () {
              if (widget.controller.text.isEmpty) {
                widget.controller.text = GenderEnum.values[0].zh;
                Member.memberModel = Member.memberModel.copyWith(gender: 0);
              }
              Navigator.of(context).pop();
            },
            cancel: () {
              widget.controller.clear();
              //更改model性別
              Member.memberModel = Member.memberModel.copyWith(gender: 0);
              Navigator.of(context).pop();
            },
            callback: (value) {
              //顯示選中性別
              widget.controller.text = GenderEnum.values[value].zh;
              //更改model性別
              Member.memberModel = Member.memberModel.copyWith(gender: value);
            },
          );
        });
  }
}

//寵物性別
class PetGenderTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? index;
  const PetGenderTextField(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.index});
  @override
  State<StatefulWidget> createState() => _PetGenderTextFieldState();
}

class _PetGenderTextFieldState extends State<PetGenderTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: _onTap,
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請選擇性別',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
    );
  }

  void _onTap() {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer<MemberPetVm>(builder: (context, vm, _) {
            return GenderPicker(
              success: () {
                if (widget.controller.text.isEmpty) {
                  widget.controller.text = GenderEnum.values[0].zh;
                  vm.setGender(GenderEnum.man.index, widget.index);
                }
                Navigator.of(context).pop();
              },
              cancel: () {
                widget.controller.clear();
                //更改model性別
                Navigator.of(context).pop();
              },
              callback: (value) {
                //顯示選中性別
                widget.controller.text = GenderEnum.values[value].zh;
                //更改model性別
                vm.setGender(value, widget.index);
              },
            );
          });
        });
  }
}

//寵物類型
class AnimalTypeTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? index;
  const AnimalTypeTextField(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.index});

  @override
  State<StatefulWidget> createState() => _AnimalTypeTextFieldState();
}

class _AnimalTypeTextFieldState extends State<AnimalTypeTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: _onTap,
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請選擇寵物類型',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
    );
  }

  void _onTap() {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer<MemberPetVm>(
            builder: (context, vm, _) {
              return AnimalTypePicker(callback: (value) {
                //顯示選中寵物類型
                widget.controller.text = AnimalType.values[value].zh;
                vm.setAnimalType(value, widget.index);
              }, success: () {
                if (widget.controller.text.isEmpty) {
                  widget.controller.text = AnimalType.values[0].zh;
                  vm.setAnimalType(AnimalType.dog.index, widget.index);
                }
                Navigator.of(context).pop();
              }, cancel: () {
                widget.controller.clear();
                Navigator.of(context).pop();
              });
            },
          );
        });
  }
}

//生日輸入框
class BirthdayTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const BirthdayTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _BirthdayTextFieldState();
}

class _BirthdayTextFieldState extends State<BirthdayTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: _onTap,
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請選擇生日',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
    );
  }

  void _onTap() {
    DateTime now = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1922, 1, 1),
        maxTime: DateTime(now.year - 18, now.month, now.day),
        onChanged: (date) {
      debugPrint('change $date');
      widget.controller.text = Utils.getBirthday(date);
      Member.memberModel = Member.memberModel.copyWith(
        birthday: Utils.getBirthday(date),
        age: Utils.getAge(Utils.getBirthday(date)),
      );
    }, onCancel: () {
      widget.controller.clear();
    }, locale: LocaleType.tw);
  }
}

//Pet生日
class PetBirthdayTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? index;
  const PetBirthdayTextField(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.index});
  @override
  State<StatefulWidget> createState() => _PetBirthdayTextFieldState();
}

class _PetBirthdayTextFieldState extends State<PetBirthdayTextField> {
  MemberPetVm? _memberPetVm;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _memberPetVm = Provider.of<MemberPetVm>(context, listen: false);
    return TextField(
      readOnly: true,
      onTap: _onTap,
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請選擇生日',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
    );
  }

  void _onTap() {
    DateTime now = DateTime.now();
    DatePicker.showPicker(
      context,
      showTitleActions: true,
      //minTime: DateTime(1922, 1, 1),
      //maxTime: DateTime(now.year, now.month, now.day),
      pickerModel: CustomYearAndMonthPicker(
        minTime: DateTime(1922, 1, 1),
        maxTime: DateTime(now.year, now.month, now.day),
        currentTime: now,
        locale: LocaleType.tw,
      ),
      onChanged: (date) {
        debugPrint('change $date');
        widget.controller.text = Utils.getPetBirthday(date);
        _memberPetVm!.setBirthday(Utils.getPetBirthday(date), widget.index);
        _memberPetVm!
            .setAge(Utils.getPetAge(Utils.getPetBirthday(date)), widget.index);
      },
      onCancel: () {
        widget.controller.clear();
      },
      locale: LocaleType.tw,
    );
    /*DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(1922, 1, 1),
        maxTime: DateTime(now.year, now.month, now.day), onChanged: (date) {
      debugPrint('change $date');
      widget.controller.text = Utils.getBirthday(date);
      _memberPetVm!.setBirthday(Utils.getBirthday(date), widget.index);
      _memberPetVm!.setAge(Utils.getAge(Utils.getBirthday(date)), widget.index);
    }, onCancel: () {
      widget.controller.clear();
    }, locale: LocaleType.tw);*/
  }
}

//搜尋輸入框
class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const SearchTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: AppColor.textFieldUnSelectBorder,
            size: 30,
          ),
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(23)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(23)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請搜尋名稱',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
    );
  }
}

//純文字貼文輸入
class JustTextPostInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const JustTextPostInputField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _JustTextPostInputFieldState();
}

class _JustTextPostInputFieldState extends State<JustTextPostInputField> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      autofocus: false,
      style: const TextStyle(color: Colors.black),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Colors.transparent,
          hintText: '想和大家分享什麼?',
          hintStyle: const TextStyle(color: Colors.black54)),
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      minLines: null,
      maxLines: null,
      scrollController: _scrollController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(200),
      ],
      onChanged: (_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCirc);
      },
    );
  }
}

//貼文輸入框
class PostInputTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const PostInputTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _PostInputTextFieldState();
}

class _PostInputTextFieldState extends State<PostInputTextField> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Colors.transparent,
          hintText: '想和大家分享什麼?',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      minLines: null,
      maxLines: null,
      scrollController: _scrollController,
      onChanged: (_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCirc);
      },
    );
  }
}

//意見輸入框
class FeedBackInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const FeedBackInputField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _FeedBackInputFieldState();
}

class _FeedBackInputFieldState extends State<FeedBackInputField> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Colors.transparent,
          hintText: '請輸入您的意見',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      minLines: null,
      maxLines: 15,
      scrollController: _scrollController,
      onChanged: (_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCirc);
      },
    );
  }
}

//留言輸入框
class CommentsTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const CommentsTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _CommentsTextFieldState();
}

class _CommentsTextFieldState extends State<CommentsTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      style: const TextStyle(
        color: AppColor.textFieldTitle,
      ),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(23)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(23)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '新增留言...',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      minLines: 1,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      controller: widget.controller,
    );
  }
}

//關於使用者輸入框
class AboutUserTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const AboutUserTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _AboutUserTextFieldState();
}

class _AboutUserTextFieldState extends State<AboutUserTextField> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '關於我...',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      minLines: null,
      maxLines: 6,
      scrollController: _scrollController,
      onChanged: (_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCirc);
      },
    );
  }
}

//年紀輸入框
class AgeTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const AgeTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _AgeTextFieldState();
}

class _AgeTextFieldState extends State<AgeTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          counterText: '',
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請輸入年齡',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      maxLength: 2,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      controller: widget.controller,
    );
  }
}

//狀態輸入框
class HealthStatusTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const HealthStatusTextField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _HealthStatusTextFieldState();
}

class _HealthStatusTextFieldState extends State<HealthStatusTextField> {
  MemberPetVm? _memberPetVm;
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _memberPetVm = Provider.of<MemberPetVm>(context, listen: false);
    return TextField(
      readOnly: true,
      onTap: _onTap,
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: '請選擇狀態',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
    );
  }

  void _onTap() async {
    int index = 0;
    bool value = await showDialog(
        context: context,
        builder: (context) {
          return HealthStatusPicker(
            callback: (value) {
              index = value;
            },
          );
        });
    if (value) {
      //顯示選中狀態
      widget.controller.text = HealthStatus.values[index].zh;
      _memberPetVm!.setHealthStatus(index, _memberPetVm!.petTarget);
    }
  }
}

//聊天室輸入框
class ChatTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool readOnly;
  const ChatTextField(
      {super.key,
      required this.readOnly,
      required this.controller,
      required this.focusNode,
      required this.hintText});
  @override
  State<StatefulWidget> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: widget.readOnly,
      autofocus: false,
      style: const TextStyle(
        color: AppColor.textFieldTitle,
      ),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColor.textFieldUnSelectBorder, width: 1),
              borderRadius: BorderRadius.circular(23)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.button, width: 1),
              borderRadius: BorderRadius.circular(23)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
          filled: true,
          fillColor: Utils.getTextFieldFillColor(widget.focusNode),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      minLines: 1,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      controller: widget.controller,
    );
  }
}

//檢舉輸入框
class ReportInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const ReportInputField(
      {super.key, required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _ReportInputFieldState();
}

class _ReportInputFieldState extends State<ReportInputField> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColor.textFieldTitle),
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          errorText: null,
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Colors.transparent,
          hintText: '請敘述申訴內容',
          hintStyle: const TextStyle(color: AppColor.textFieldHintText)),
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      minLines: null,
      maxLines: 5,
      scrollController: _scrollController,
      onChanged: (_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCirc);
      },
    );
  }
}
