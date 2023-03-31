import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  const CustomRadioListTile(
      {Key key,
      @required this.value,
      @required this.groupValue,
      @required this.onChanged,
      this.toggleable = false,
      this.activeColor,
      this.title,
      this.subtitle,
      this.isThreeLine = false,
      this.dense,
      this.secondary,
      this.selected = false,
      this.controlAffinity = ListTileControlAffinity.platform,
      this.autofocus = false,
      this.paddings})
      : assert(!isThreeLine || subtitle != null),
        super(key: key);

  final T value;

  /// The currently selected value for this group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio tile with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// RadioListTile<SingingCharacter>(
  ///   title: const Text('Lafayette'),
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final onChanged;

  final bool toggleable;

  /// The color to use when this radio button is selected.
  ///
  /// Defaults to accent color of the current [Theme].
  final Color activeColor;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget subtitle;

  /// A widget to display on the opposite side of the tile from the radio button.
  ///
  /// Typically an [Icon] widget.
  final Widget secondary;

  /// Whether this list tile is intended to display three lines of text.
  ///
  /// If false, the list tile is treated as having one line if the subtitle is
  /// null and treated as having two lines if the subtitle is non-null.
  final bool isThreeLine;

  /// Whether this list tile is part of a vertically dense list.
  ///
  /// If this property is null then its value is based on [ListTileTheme.dense].
  final bool dense;

  final EdgeInsetsGeometry paddings;

  /// Whether to render icons and text in the [activeColor].
  ///
  /// No effort is made to automatically coordinate the [selected] state and the
  /// [checked] state. To have the list tile appear selected when the radio
  /// button is the selected radio button, set [selected] to true when [value]
  /// matches [groupValue].
  ///
  /// Normally, this property is left to its default value, false.
  final bool selected;

  final ListTileControlAffinity controlAffinity;

  final bool autofocus;

  bool get checked => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final Widget control = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      toggleable: toggleable,
      activeColor: activeColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      autofocus: autofocus,
    );
    Widget leading, trailing;
    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
      case ListTileControlAffinity.platform:
        leading = control;
        if (secondary != null) {
          trailing = secondary;
        }
        break;
      case ListTileControlAffinity.trailing:
        if (secondary != null) {
          leading = secondary;
        }
        trailing = control;
        break;
    }
    return Container(
      width: 100,
      child: MergeSemantics(
        child: ListTileTheme.merge(
          contentPadding: paddings,
          selectedColor: activeColor ?? Theme.of(context).primaryColor,
          child: ListTile(
            horizontalTitleGap: 5,
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            isThreeLine: isThreeLine,
            dense: dense,
            enabled: onChanged != null,
            onTap: onChanged != null
                ? () {
                    if (toggleable && checked) {
                      onChanged(null);
                      return;
                    }
                    if (!checked) {
                      onChanged(value);
                    }
                  }
                : null,
            selected: selected,
            autofocus: autofocus,
          ),
        ),
      ),
    );
  }
}
