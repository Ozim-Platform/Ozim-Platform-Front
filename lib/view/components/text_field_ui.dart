import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charity_app/utils/device_size_config.dart';

class TextFieldUI extends StatefulWidget {
  const TextFieldUI({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.style,
    this.validator,
    this.onFieldSubmitted,
    this.decoration,
    this.prefixIcon,
    this.prefixText,
    this.keyboardType = TextInputType.multiline,
    this.text,
    this.controller,
    this.inputFormatters,
    this.minLine = 1,
    this.maxLine = 1,
    this.inputAction = TextInputAction.next,
    this.obscureText = false,
  });

  final Key fieldKey;
  final String text;
  final String hintText;
  final String labelText;
  final String helperText;
  final TextStyle style;
  final TextEditingController controller;
  final prefixIcon;
  final prefixText;
  final keyboardType;
  final OutlineInputBorder decoration;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final minLine;
  final maxLine;
  final TextInputAction inputAction;
  final bool obscureText;

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldUI> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: 0.5,
            child: Text(
              widget.text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              // textScaleFactor: SizeConfig.textScaleFactor(),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          obscureText: widget.obscureText,
          autofocus: false,
          textInputAction: widget.inputAction,
          controller: widget.controller,
          inputFormatters: widget.inputFormatters,
          textCapitalization: TextCapitalization.sentences,
          onSaved: widget.onSaved,
          minLines: widget.minLine,
          maxLines: widget.maxLine,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0,),
            border: OutlineInputBorder(
              borderSide: const BorderSide(),
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: false,
            hintText: widget.hintText,
            hintStyle:
                TextStyle(color: const Color(0xff272836).withOpacity(0.5),),
            labelText: widget.labelText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            prefixText: widget.prefixText,
          ),
        ),
      ],
    );
  }
}
