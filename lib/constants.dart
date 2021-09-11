// App wide constants

import 'package:flutter/material.dart';

//App Title
const String appTitle = 'Countdown Timer ⏳';

// The circular progress indicator dimensions for web
const double circularProgressIndicatorDimensionsForWeb = 400;
// This edge insets padding warps the 'TimerPicker' & 'CircularProgressIndicator' stack
const EdgeInsets edgeInsetsPadding = EdgeInsets.all(32.0);
// The elevated buttons edge insets padding (Left & Right control buttons)
const EdgeInsets elevatedButtonPadding = EdgeInsets.all(12.0);

// Countdown duration text style
const TextStyle countdownDurationTextStyle = TextStyle(
    color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 48);
// Elevated Button text style
const TextStyle elevatedButtonTextStyle = TextStyle(color: Colors.white);

// Circular progress indicator startup color
const Color circularProgressIndicatorStartupColor = Colors.blueGrey;
// Circular progress indicator head color
const Color circularProgressIndicatorHeadColor = Colors.red;
// Circular progress indicator value color
const Color circularProgressIndicatorValueColor = Colors.orange;
// Circular progress indicator done (complete) color
const Color circularProgressIndicatorDoneColor = Colors.green;
