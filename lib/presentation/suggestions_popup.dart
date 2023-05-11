import 'package:flutter/material.dart';

/// A [StatelessWidget] that is inserted in the [Overlay].
/// This widget represents the pop up that appears when a mistake is present in
/// the text.
class SuggestionsPopup extends StatelessWidget {
  /// The x component of offset.
  final double dx;

  /// The y component of offset.
  final double dy;

  /// represents the [Color] of the mistake for which
  /// the [SuggestionsPopup] is being displayed.
  final Color mistakeColor;

  /// represents the name of the mistake.
  final String mistakeName;

  /// The description of the mistake.
  final String mistakeMessage;

  /// List that contains the replacement for the given mistake
  final List<String> replacements;

  /// A callback that will run when a suggestion is pressed.
  final void Function(String suggestion) onTapCallback;

  /// A callback function that will pop [SuggestionsPopup] from the [Overlay]
  final void Function() closeCallBack;

  /// Constructor for the [SuggestionsPopup] widget.
  const SuggestionsPopup({
    required this.mistakeName,
    required this.mistakeMessage,
    required this.mistakeColor,
    required this.replacements,
    required this.onTapCallback,
    required this.closeCallBack,
    required this.dx,
    required this.dy,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: dy,
      left: dx,
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: 250.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mistakeColor,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: Text(
                        mistakeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 20.0,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: closeCallBack,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  mistakeMessage,
                  softWrap: true,
                ),
                const SizedBox(height: 20.0),
                Wrap(
                  children: replacements
                      .map(
                        (elem) => GestureDetector(
                          onTap: () {
                            onTapCallback(elem);
                            closeCallBack();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              right: 5.0,
                              bottom: 5.0,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              elem,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
