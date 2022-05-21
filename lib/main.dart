import 'package:flutter/material.dart';
import 'mobile_audio.dart' if (dart.library.js) 'web_audio.dart';

Stream<double>? stream;

void main() async {
  stream = getAudioLevelStream();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Level Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showLevel = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Level Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'The auido level is:',
            ),
            if (_showLevel)
              StreamBuilder<double>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  } else {
                    return const Text('No data');
                  }
                },
              ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _showLevel = !_showLevel;
                  });
                },
                child: const Text('Toggle level'))
          ],
        ),
      ),
    );
  }
}
