## 1.0.0

### BREAKING CHANGES

- `build!`: require Flutter 3.27.0 or higher and Dart 3.0.0 or higher ([#91](https://github.com/solid-software/languagetool_textfield/pull/91))
- `LanguageToolTextField` now extends Flutter's `TextField` instead of `StatefulWidget` ([#90](https://github.com/solid-software/languagetool_textfield/pull/90))
- rename `LanguageToolTextField` parameters to match `TextField`'s naming ([#90](https://github.com/solid-software/languagetool_textfield/pull/90))
  - `autoFocus` -> `autofocus`
  - `onTextChange` -> `onChanged`
  - `onTextSubmitted` -> `onSubmitted`
- rename language check services and move them to `wrappers/` ([#93](https://github.com/solid-software/languagetool_textfield/pull/93), [9157f8c](https://github.com/solid-software/languagetool_textfield/commit/9157f8c39b0defe6c3dda6d6e2945980fad67594))
  - `LangToolService` -> `LanguageToolService`
  - `DebounceLangToolService` -> `DebounceLanguageCheckService`
  - `ThrottlingLangToolService` -> `ThrottlingLanguageCheckService`
- hide `baseService`, `debouncing` and `throttling` fields from the debouncing and throttling wrappers ([#93](https://github.com/solid-software/languagetool_textfield/pull/93), [9157f8c](https://github.com/solid-software/languagetool_textfield/commit/9157f8c39b0defe6c3dda6d6e2945980fad67594))
- remove `delayType` and `delay` fields from `LanguageToolController`; they remain constructor parameters ([#93](https://github.com/solid-software/languagetool_textfield/pull/93))
- `LanguageCheckService` implementations must now provide a `language` getter and setter ([#93](https://github.com/solid-software/languagetool_textfield/pull/93), [8f2b230](https://github.com/solid-software/languagetool_textfield/commit/8f2b230cadf60f2886fc009c396528bbdf1c99ba))

### New Features

- allow overriding `languageCheckService` on `LanguageToolController` for full control over how text is analyzed ([#93](https://github.com/solid-software/languagetool_textfield/pull/93))
- add `isEnabled` to toggle spell check ([#92](https://github.com/solid-software/languagetool_textfield/pull/92))
- support adding words to dictionary through the `addWordToDictionary` callback in `LanguageToolMistakePopup` ([#95](https://github.com/solid-software/languagetool_textfield/pull/95), [9de4a15](https://github.com/solid-software/languagetool_textfield/commit/9de4a153a381959713ef971932afd8cef83a69cc))
- add `FilteredLanguageCheckService` to drop mistakes matching a custom predicate ([#95](https://github.com/solid-software/languagetool_textfield/pull/95))
- add `LanguageToolController.recheckText()` to force a recheck without changing the text ([#95](https://github.com/solid-software/languagetool_textfield/pull/95), [9de4a15](https://github.com/solid-software/languagetool_textfield/commit/9de4a153a381959713ef971932afd8cef83a69cc))
- export `Result` to allow custom `LanguageCheckService` implementations ([#95](https://github.com/solid-software/languagetool_textfield/pull/95))
- add missing properties from Flutter's `TextField` ([#90](https://github.com/solid-software/languagetool_textfield/pull/90))
  - autofillHints
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

### Fixes

- mistake popup is now themed with the app's `ColorScheme`, fixing visibility in dark mode ([#88](https://github.com/solid-software/languagetool_textfield/pull/88))
- recheck text when the language changes ([#96](https://github.com/solid-software/languagetool_textfield/pull/96), [cae2cba](https://github.com/solid-software/languagetool_textfield/commit/cae2cba337ac9c2973d534159265f072c3a050ea))
- clear mistakes that fall out of the new text range, fixing a `RangeError` when changing text programmatically ([#97](https://github.com/solid-software/languagetool_textfield/pull/97))
- prevent notifying listeners after an async gap when the controller is disposed ([#97](https://github.com/solid-software/languagetool_textfield/pull/97))
- `ThrottlingLanguageCheckService` now discards mistakes with offsets outside the checked text's range ([#95](https://github.com/solid-software/languagetool_textfield/pull/95))
- avoid setting `scrollOffset` before the scroll controller is attached ([#100](https://github.com/solid-software/languagetool_textfield/pull/100))
- `style`: use the default `IconButton` padding in the mistake popup ([#95](https://github.com/solid-software/languagetool_textfield/pull/95), [9de4a15](https://github.com/solid-software/languagetool_textfield/commit/9de4a153a381959713ef971932afd8cef83a69cc))

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
