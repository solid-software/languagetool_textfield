import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';

const _defaultElevation = 8.0;
const _defaultWidth = 8.0;
const _defaultSpacing = 8.0;
const _defaultBorderRadius = BorderRadius.all(Radius.circular(12));

/// Shortcut for replacement builder callback
typedef ReplacementBuilder = Widget Function(String);

/// Default implementation for widget in mistake popup
class MistakeTile extends StatelessWidget {
  /// Info about current mistake
  final Mistake mistake;

  /// Popup elevation
  final double elevation;

  /// Widget width
  final double width;

  /// Spacing between replacements
  final double spacing;

  /// Popup border radius
  final BorderRadius? borderRadius;
  final ReplacementBuilder _replacementBuilder;

  /// Constructor
  const MistakeTile(
    this.mistake, {
    Key? key,
    this.elevation = _defaultElevation,
    this.width = _defaultWidth,
    this.spacing = _defaultSpacing,
    this.borderRadius = _defaultBorderRadius,
    ReplacementBuilder? replacementBuilder,
  })  : _replacementBuilder = replacementBuilder ?? _DefaultReplacement.new,
        super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        elevation: elevation,
        color: Colors.white,
        borderRadius: borderRadius,
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(mistake.type.name),
              Text(mistake.description),
              Wrap(
                runSpacing: spacing,
                spacing: spacing,
                children: mistake.replacements
                    .map(_replacementBuilder)
                    .toList(growable: false),
              ),
            ],
          ),
        ),
      );
}

class _DefaultReplacement extends StatelessWidget {
  final String replacement;

  const _DefaultReplacement(this.replacement, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(8),
          backgroundColor: Colors.blueAccent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: () {
          // TODO: Add callback
        },
        child: Text(replacement),
      );
}
