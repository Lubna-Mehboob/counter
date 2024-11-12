import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerScreen extends StatefulWidget {
  @override
  _CountdownTimerScreenState createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  Timer? _timer;
  Duration _timeRemaining =
      const Duration(minutes: 1); // Default time (1 minute)
  Duration _initialTime = const Duration(minutes: 1);
  bool _isRunning = false;

  // Start Timer
  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_timeRemaining.inMilliseconds > 0) {
          _timeRemaining = _timeRemaining - const Duration(milliseconds: 10);
        } else {
          _stopTimer();
        }
      });
    });
  }

  // Stop Timer
  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
    });
  }

  // Reset Timer
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _timeRemaining = _initialTime;
    });
  }

  // Set the initial countdown duration
  void _setTime(Duration time) {
    setState(() {
      _initialTime = time;
      _timeRemaining = time;
    });
  }

  // Format Duration to HH:MM:SS:MS (with two-digit milliseconds)
  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = (duration.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0'); // Two digits for milliseconds
    return "$hours:$minutes:$seconds:$milliseconds";
  }

  // Show Time Picker for User to Set Time
  Future<void> _pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _initialTime.inHours,
        minute: _initialTime.inMinutes.remainder(60),
      ),
    );

    if (pickedTime != null) {
      Duration selectedDuration =
          Duration(hours: pickedTime.hour, minutes: pickedTime.minute);
      _setTime(selectedDuration);
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Countdown Timer'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 165, 150, 209),
              Color.fromARGB(255, 97, 100, 105)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(_timeRemaining),
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isRunning ? null : () => _pickTime(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Set Time'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _isRunning ? _stopTimer : _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isRunning ? Colors.redAccent : Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(_isRunning ? 'Stop' : 'Start'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Time Remaining Progress',
                style: TextStyle(
                    color: Color.fromARGB(179, 112, 5, 94), fontSize: 16),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(5),
                value:
                    _timeRemaining.inMilliseconds / _initialTime.inMilliseconds,
                backgroundColor: Colors.white30,
                color: const Color.fromARGB(255, 10, 3, 29),
                minHeight: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
