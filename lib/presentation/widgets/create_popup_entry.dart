import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

/// Creates a popup with mistake description on highlighted text tap
void createPopupEntry({
  required Offset globalPosition,
  required BuildContext context,
  required Mistake mistake,
  required Color color,
}) {
  showDialog<Dialog>(
    context: context,
    builder: (BuildContext context) {
      ///Default value for radius, margin, circle size
      const double defaultValue = 8;

      ///Capitalizing mistake type
      final String mistakeType =
          mistake.type.name[0].toUpperCase() + mistake.type.name.substring(1);

      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned(
              left: globalPosition.dx,
              top: globalPosition.dy,
              child: Material(
                elevation: defaultValue,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(defaultValue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: defaultValue,
                            width: defaultValue,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          ),
                          const SizedBox(
                            width: defaultValue,
                          ),
                          Text(
                            mistakeType,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: defaultValue,
                      ),
                      Text(
                        mistake.message,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Dismiss Dialog
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    },
    barrierColor: Colors.transparent,
  );
}
