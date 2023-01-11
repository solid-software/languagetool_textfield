<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# LanguageTool Text Field 
## Features
- Spell checking with the highly precise LangTool AI.
- Mistakes are highlighted and easy to spot.


## Getting started
To get started, install the package, import and use the LanguageToolTextField Widget with required parameters of width and height like the normal Container

## Usage
First install it, then use:
``` import 'package:languagetool_text_field/languagetool_text_field.dart'``` 

In your code you can do something like:

```
...
body: Center(
        child: LanguageToolTextField(
        height: heigth,
        width: width,
        decoration: InputDecoration(
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(circularRadius),
            ),
        ),
        maxLines: maxLines,
        //defaultMistakeStyle: TextStyle(fontSize: 60),
        //styleMistakeStyle: TextStyle(fontSize: 60),
        ),
    ),
    ...
```

