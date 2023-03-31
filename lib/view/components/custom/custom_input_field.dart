import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/material.dart';

class InputMessageField extends StatelessWidget {
  final ValueChanged<String> callback;
  final String hint;
  final String avatar;
  final bool withavatar;
  final bool autofocus;

  InputMessageField(
      {Key key,
      this.callback,
      this.hint,
      this.avatar,
      this.withavatar = true,
      this.autofocus = true})
      : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (withavatar)
          UserImage(
            userUrl: avatar,
          ),
        if (withavatar)
          SizedBox(
            width: 20,
          ),
        Expanded(
          child: Container(
            child: TextField(
              autofocus: autofocus,
              focusNode: FocusNode(),
              controller: _textController,
              textInputAction: TextInputAction.send,
              onSubmitted: callback,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                hintText: getTranslated(context, hint),
                hintStyle: AppThemeStyle.normalText,
                hintMaxLines: 1,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            callback(_textController.text);
            _textController.text = '';
          },
          child: Icon(
            Icons.send,
            color: AppThemeStyle.primaryColor,
            size: 28,
          ),
        )
      ],
    );
  }
}
