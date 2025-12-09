import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyFirstApp());

class MyFirstApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Download Demo',
      debugShowCheckedModeBanner: false,
      home: DownloadScreen(),
    );
  }
}

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  bool _isLoading = false;
  double _progressValue = 0.0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startDownload() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
    });

    const oneSec = Duration(milliseconds: 500);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _progressValue += 0.1; 

        if (_progressValue >= 1.0) {
          _progressValue = 1.0;
          _isLoading = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final percentText = '${(_progressValue * 100).round()}%';

    return Scaffold(
      appBar: AppBar(
        title: Text('My First App'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isLoading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LinearProgressIndicator(value: _progressValue),
                    const SizedBox(height: 16),
                    Text(
                      percentText,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Завантаження триває...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(Icons.cloud_download, size: 64, color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Натисніть кнопку, щоб почати завантаження',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startDownload,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
