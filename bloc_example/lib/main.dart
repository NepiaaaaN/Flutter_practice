import 'dart:async';
import 'business_logic.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var intStream = StreamController<int>();
  var timerStream = StreamController<String>();
  var stringStream = StreamController<String>.broadcast();

  // 初期化時に各クラスにStreamを流す
  @override
  void initState() {
    super.initState();
    Generator(intStream, timerStream);
    Coordinator(intStream, stringStream);
    Consumer(stringStream);
  }

  // 終了時にStreamを解放する
  @override
  void dispose() {
    super.dispose();
    intStream.close();
    stringStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<String>(
                stream: timerStream.stream,
                initialData: '',
                builder: ((context, snapshot) {
                  return Text(
                      'A number is displayed on the screen after ${snapshot.data} seconds:');
                })),
            StreamBuilder<String>(
              stream: stringStream.stream,
              initialData: "",
              builder: ((context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
