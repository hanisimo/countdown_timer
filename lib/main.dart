import 'dart:async';
import 'dart:io' show Platform;

import 'package:countdown_timer/timer_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer ⏳',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(),
      home: MyHomePage(title: 'Countdown Timer  ⏳'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Timer _countdownTimer;
  TimerStatus _timerStatue = TimerStatus.set;
  Duration _timerDuration = const Duration(hours: 0, minutes: 3, seconds: 0);
  int _restTimerDurationInSeconds = 3 * 60;
  String _countdownTimerAsString = '0:3:0'; // Start -> Pause -> Resume
  String _leftControlButtonText = 'Start'; // Start -> Pause -> Resume
  IconData _leftControlButtonIcon = Icons.play_arrow;
  String _rightControlButtonText = 'Set Timer'; // Set Timer -> Reset
  IconData _rightControlButtonIcon = Icons.restore;

  void startCountdownTimer({int seconds}) {
    const oneSecondPeriod = const Duration(seconds: 1);

    if ((_countdownTimer != null) && (_countdownTimer.isActive)) {
      _countdownTimer.cancel();
    }
    _countdownTimer = new Timer.periodic(
      oneSecondPeriod,
      (Timer timer) {
        if (_timerStatue == TimerStatus.started)
          setState(() {
            _restTimerDurationInSeconds--;
            _countdownTimerAsString = _durationAsString(
                duration: Duration(seconds: _restTimerDurationInSeconds));
          });

        if (_restTimerDurationInSeconds == 0) {
          setState(() {
            _timerStatue = TimerStatus.finished;
            _leftControlButtonText = 'Start';
            _leftControlButtonIcon = Icons.play_arrow;

            timer.cancel();
          });
        }
      },
    );
  }

  // Duration As String
  String _durationAsString({Duration duration}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = false;
    try {
      if ((Platform.isAndroid) || (Platform.isIOS)) {
        isMobile = true;
      } else {
        isMobile = false;
      }
    } catch (e) {
      isMobile = false;
    }
    double circularProgressIndicatorDimensions =
        isMobile ? MediaQuery.of(context).size.width - 64 : 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _timerStatue == TimerStatus.set
              ? Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: circularProgressIndicatorDimensions,
                      maxWidth: double.infinity,
                      minHeight: circularProgressIndicatorDimensions,
                      maxHeight: double.infinity,
                    ),
                    child: CupertinoTimerPicker(
                        mode: CupertinoTimerPickerMode.hms,
                        initialTimerDuration: _timerDuration,
                        onTimerDurationChanged: (Duration duration) {
                          _timerDuration = duration;
                        }),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Stack(children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: circularProgressIndicatorDimensions,
                        maxWidth: double.infinity,
                        minHeight: circularProgressIndicatorDimensions,
                        maxHeight: double.infinity,
                      ),
                      child: Center(
                        child: Text(
                          '$_countdownTimerAsString',
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 48),
                        ),
                      ),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: circularProgressIndicatorDimensions,
                          maxWidth: double.infinity,
                          minHeight: circularProgressIndicatorDimensions,
                          maxHeight: double.infinity,
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 24,
                          backgroundColor: Colors.blueGrey,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.red),
                          value: 1 -
                              (_restTimerDurationInSeconds /
                                  _timerDuration.inSeconds) +
                              0.002,
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: circularProgressIndicatorDimensions,
                          maxWidth: double.infinity,
                          minHeight: circularProgressIndicatorDimensions,
                          maxHeight: double.infinity,
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 24,
                          value: 1 -
                              (_restTimerDurationInSeconds /
                                  _timerDuration.inSeconds),
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              (_timerStatue != TimerStatus.finished)
                                  ? Colors.orange
                                  : Colors.green),
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                    ),
                  ]),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: (_timerStatue == TimerStatus.finished) ? false : true,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    icon: Icon(_leftControlButtonIcon),
                    label: Text(
                      _leftControlButtonText,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // Set -> Start -> Pause -> Resume
                      switch (_timerStatue) {
                        case TimerStatus.set: // Start Now
                          _restTimerDurationInSeconds =
                              _timerDuration.inSeconds;
                          startCountdownTimer(
                              seconds: _restTimerDurationInSeconds);
                          _timerStatue = TimerStatus.started;
                          setState(() {
                            _countdownTimerAsString = _durationAsString(
                                duration: Duration(
                                    seconds: _restTimerDurationInSeconds));
                            _leftControlButtonText = 'Pause';
                            _leftControlButtonIcon = Icons.pause;
                          });
                          break;
                        case TimerStatus.started: // Stop Now
                          _timerStatue = TimerStatus.paused;

                          setState(() {
                            _leftControlButtonText = 'Resume';
                            _leftControlButtonIcon = Icons.play_arrow;
                          });
                          break;
                        case TimerStatus.paused: // Resume Now
                          // Pause the Timer Now (started -> paused)
                          _timerStatue = TimerStatus.started;
                          setState(() {
                            _leftControlButtonText = 'Pause';
                            _leftControlButtonIcon = Icons.pause;
                          });
                          break;
                        case TimerStatus.finished: // Restart
                          _restTimerDurationInSeconds =
                              _timerDuration.inSeconds;
                          startCountdownTimer(
                              seconds: _restTimerDurationInSeconds);
                          _timerStatue = TimerStatus.started;
                          setState(() {
                            _leftControlButtonText = 'Pause';
                            _leftControlButtonIcon = Icons.pause;
                          });
                          break;
                      }
                    },
                  ),
                ),
              ),
              Visibility(
                visible: (_timerStatue == TimerStatus.set) ? false : true,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    icon: Icon(_rightControlButtonIcon),
                    label: Text(
                      _rightControlButtonText, // -> Pause -> Resume
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _timerStatue = TimerStatus.set;
                        _leftControlButtonText = 'Start';
                        _leftControlButtonIcon = Icons.play_arrow;
                      });
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
