import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';

const _defaultElevation = 8.0;
const _defaultWidth = 8.0;
const _defaultSpacing = 8.0;

class MistakeTile extends StatelessWidget {
  final Mistake mistake;
  final double elevation;
  final double width;
  final double spacing;

  const MistakeTile(
    this.mistake, {
    Key? key,
    this.elevation = _defaultElevation,
    this.width = _defaultWidth,
    this.spacing = _defaultSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        elevation: elevation,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                children: [
                  for (final replacement in mistake.replacements)
                    TextButton(
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
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}
