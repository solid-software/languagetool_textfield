# LanguageTool TextField
[![style: solid](https://img.shields.io/badge/style-solid-orange)](https://pub.dev/packages/solid_lints)
[![langtool](https://nokycucwgzweensacwfy.supabase.co/functions/v1/get_project_badge?projectName=LanguageTool%20TextField)](https://www.worklog.ai)

Providing powerful spell-checking and grammar correction capabilities.

<div>
<img src="https://raw.githubusercontent.com/solid-software/languagetool_textfield/master/doc/misspeling_langtool.png" width="310" height="667">
&nbsp
&nbsp
<img src="https://raw.githubusercontent.com/solid-software/languagetool_textfield/master/doc/typo_langtool.png" width="310" height="667">
&nbsp
&nbsp
<img src="https://raw.githubusercontent.com/solid-software/languagetool_textfield/master/doc/uncategorized_langtool.png" width="310" height="667">
</div>

## Features

The LanguageTool TextField package is a spell-checker designed for Flutter apps. It integrates with the LanguageTool API to offer real-time spell-checking capabilities. This package will enhance text input accuracy by automatically detecting and highlighting spelling errors as users type. 

It's particularly useful for apps that require precise text input, like chat or note-taking apps. By using the LanguageTool TextField package, developers can improve the user experience by providing an intuitive and reliable spell-checking feature.


## Getting started

1. Run this command:

```dart
flutter pub add languagetool_textfield
```

2. Import the package:

```dart
import 'package:languagetool_textfield/languagetool_textfield.dart';
```


## Quick Start
To start using the plugin, copy this code or follow the example project in 'languagetool_textfield/example'

```dart
// Create a text controller for the Widget
final _controller = LanguageToolController();

// Use the text field widget in your layout
child: LanguageToolTextField(
  controller: _controller,

  // A language code like en-US, de-DE, fr, or auto to guess
  // the language automatically.
  // language = 'auto' by default.
  language: 'en-US',
);

// Don't forget to dispose the controller
_controller.dispose();
```

## Using Debounce and Throttle in LanguageTool TextField

To incorporate the debounce or throttle functionality into the `LanguageTool TextField`, follow these:

Create a `LanguageToolController` and provide the desired debounce/throttle delay duration and delay type:
   ```dart
   final _controller = LanguageToolController(
     // If the delay value is [Duration.zero], no delay is applied.
     delay: Duration(milliseconds: 500), // Set the debounce/throttle delay duration here
     delayType: DelayType.debouncing, // Choose either DelayType.debouncing or DelayType.throttling
   );
```

  `DelayType.debouncing` - Calls a function when a user hasn't carried out the event in a specific amount of time.

  `DelayType.throttling` - Calls a function at intervals of a specified amount of time while the user is carrying out the event.

## Legal

This is an unofficial plugin. We are not affiliated with LanguageTool.
All logos are of their respected owners.

## Current issues

Current issues list [is here](https://github.com/solid-software/languagetool_textfield/issues).\
Found a bug? [Open the issue](https://github.com/solid-software/languagetool_textfield/issues/new).

