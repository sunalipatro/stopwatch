import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 163, 0, 185),
            background: Color.fromARGB(255, 154, 9, 173)),
      ),
      home: StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  bool _isRunning = false;
  bool _isHolding = false;
  int _milliseconds = 0;
  late Stopwatch _stopwatch;
  late ValueNotifier<int> _notifier;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _notifier = ValueNotifier<int>(_milliseconds);
  }

  void _startStopwatch() {
    if (!_isRunning) {
      _isRunning = true;
      _isHolding = false;
      _stopwatch.start();
      _updateTimer();
    } else {
      _isRunning = false;
      _stopwatch.stop();
    }
  }

  void _holdStopwatch() {
    if (_isRunning) {
      _isRunning = false;
      _isHolding = true;
      _stopwatch.stop();
    }
  }

  void _resetStopwatch() {
    _isRunning = false;
    _isHolding = false;
    _stopwatch.reset();
    _notifier.value = 0;
  }

  void _updateTimer() {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (_isRunning) {
        _notifier.value = _stopwatch.elapsedMilliseconds;
        _updateTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _notifier,
              builder: (context, milliseconds, _) {
                final Duration duration = Duration(milliseconds: milliseconds);
                return Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 167, 126, 164),
                      borderRadius: BorderRadius.all(Radius.circular(2000)),
                    ),
                    margin: const EdgeInsets.all(10.0),
                    width: 350,
                    height: 150,
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 87,
                          ),
                          Text(
                            '${duration.inMinutes.toString().padLeft(2, '0')}:',
                            style: const TextStyle(fontSize: 36.0),
                          ),
                          Text(
                            '${(duration.inSeconds % 60).toString().padLeft(2, '0')}.',
                            style: const TextStyle(fontSize: 36.0),
                          ),
                          Text(
                            '${(duration.inMilliseconds % 100).toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 36.0),
                          )
                        ],
                      ),
                    ));

                // return Text(
                //   '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}.${(duration.inMilliseconds % 100).toString().padLeft(2, '0')}',
                //   style: TextStyle(fontSize: 36.0),
                // );
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startStopwatch,
                  child: Text(_isRunning ? 'Stop' : 'Start'),
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: _holdStopwatch,
                  child: const Text('Hold'),
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _notifier.dispose();
    super.dispose();
  }
}
