## 1.1.0

- Add `isEnabled` to toggle spell check
- Allow overriding `languageCheckService`

## 1.0.0

- BREAKING: require flutter 3.27.0 or higher
- BREAKING: require dart 3.0.0 or higher
- BREAKING: rename autoFocus to autofocus to match `TextField`'s naming
- Add missing properties from flutter's `TextField`
  - autofillHints
  - autofocus
  - buildCounter
  - canRequestFocus
  - clipBehavior
  - contentInsertionConfiguration
  - contextMenuBuilder
  - cursorErrorColor
  - cursorHeight
  - cursorOpacityAnimates
  - cursorRadius
  - cursorWidth
  - dragStartBehavior
  - enabled
  - enableIMEPersonalizedLearning
  - enableInteractiveSelection
  - enableSuggestions
  - ignorePointers
  - inputFormatters
  - key
  - magnifierConfiguration
  - maxLength
  - maxLengthEnforcement
  - obscureText
  - obscuringCharacter
  - onTapAlwaysCalled
  - onTapUpOutside
  - restorationId
  - scrollController
  - scrollPadding
  - scrollPhysics
  - selectionControls
  - selectionHeightStyle
  - selectionWidthStyle
  - showCursor
  - smartDashesType
  - smartQuotesType
  - spellCheckConfiguration
  - statesController
  - strutStyle
  - stylusHandwritingEnabled
  - textAlignVertical
  - textCapitalization
  - undoController

## 0.1.1

- Fix changelog

## 0.1.0

- Moved implementation into the `src` directory
- Updated dependencies
- Add some properties (cursorColor, onTextChange, focusNode, onTextSubmitted, ...) for TextField
    Credits: @dab246
- Replace deprecated MaterialStateMouseCursor

## 0.0.6

- Add textAlign and textDirection arguments to LanguageToolTextField constructor
- Enforce utf-8 decoding format for LanguageTool API responses.

Credits: @Semsem-programmer

## 0.0.5

Fixed a mistake found in the "Getting Started" section

## 0.0.4

Simpler and cleaner API. Documentation updates.

## 0.0.3

Update pub.dev image links.

## 0.0.2

Update pub.dev image links.

## 0.0.1

Initial release that provides basic suggestions.
