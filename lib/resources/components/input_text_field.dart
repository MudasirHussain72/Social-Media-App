import 'package:flutter/material.dart';
import 'package:hive_mind/resources/color.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFieldSubmittedValue;
  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final String hint;
  final bool obscureText;
  final bool enable, autoFocus;
  // ignore: prefer_typing_uninitialized_variables
  final maxLength;
  const InputTextField(
      {super.key,
      required this.myController,
      required this.focusNode,
      required this.onFieldSubmittedValue,
      required this.onValidator,
      required this.keyBoardType,
      required this.hint,
      required this.obscureText,
      this.enable = true,
      this.maxLength,
      this.autoFocus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        maxLength: maxLength,
        controller: myController,
        focusNode: focusNode,
        obscureText: obscureText,
        onFieldSubmitted: onFieldSubmittedValue,
        validator: onValidator,
        keyboardType: keyBoardType,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 19),
        decoration: InputDecoration(
          hintText: hint,
          enabled: enable,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: AppColors.primaryTextTextColor),
          border:const  OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textFieldDefaultFocus),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textFieldDefaultFocus),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.alertColor),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.textFieldDefaultBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}
