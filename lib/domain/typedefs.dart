import 'package:flutter/widgets.dart';
import 'package:languagetool_textfield/core/controllers/colored_text_editing_controller.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/utils/popup_overlay_renderer.dart';

/// Callback used to build popup body
typedef MistakeBuilderCallback = Widget Function({
  required PopupOverlayRenderer popupRenderer,
  required Mistake mistake,
  required ColoredTextEditingController controller,
  required Offset mistakePosition,
});

/// Function called after mistake was clicked
typedef ShowPopupCallback = void Function(
  BuildContext context,
  Mistake mistake,
  Offset mistakePosition,
  ColoredTextEditingController controller,
);
