import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';

class MistakeTile extends StatelessWidget {
  static const _elevation = 8.0;

  final Mistake mistake;

  const MistakeTile(this.mistake, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        elevation: _elevation,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: SizedBox(
          width: 128,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(mistake.type.name),
              Text(mistake.description),
              Wrap(
                runSpacing: 8,
                spacing: 8,
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
