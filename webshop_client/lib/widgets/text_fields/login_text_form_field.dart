import 'package:flutter/material.dart';

class LoginTextFormField extends StatefulWidget {

  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final List<String> autofillHints;
  final FormFieldValidator<String> validator;
  final IconData icon;
  final bool autofocus;
  final TextInputAction textInputAction;
  final TextInputType inputType;


  const LoginTextFormField({super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.autofillHints,
    required this.validator,
    required this.icon,
    this.obscureText=false,
    this.autofocus=false,
    this.textInputAction = TextInputAction.next,
    this.inputType = TextInputType.text
  });

  @override
  State<LoginTextFormField> createState() => _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  bool hidePassword=false;

  @override
  void initState() {
    super.initState();
    hidePassword=widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText && hidePassword,
      autofillHints: widget.autofillHints,
      autofocus: widget.autofocus,
      enableSuggestions: true,
      autovalidateMode: AutovalidateMode.disabled,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      keyboardType: widget.inputType,
      decoration: InputDecoration (
          prefixIcon: Icon(widget.icon),
          labelText: widget.labelText,
          hintText: widget.hintText,
          //make password obscured/visible
          suffixIcon: getObscureButton()
      ),
    );
  }

  Widget? getObscureButton() {
    if (widget.obscureText) {
      return InkWell(
          canRequestFocus: false, //solves bug: this gains focus on edit next ime action instead of the next textfield
          customBorder: const CircleBorder(),
          child: Icon(hidePassword? Icons.visibility: Icons.visibility_off),
          onTap: (){
            setState(() {
              hidePassword=!hidePassword;
            });
          },
        );
    } else {
      return null;
    }
  }
}
