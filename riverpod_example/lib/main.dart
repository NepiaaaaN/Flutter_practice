import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mydata.dart';

// 1-1. グローバル変数にProviderを定義する
final _mydataProvider =
    StateNotifierProvider<MyData, double>((ref) => MyData());

void main() {
  // 1-2. ProviderScopeを設定する
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // 2-1. Text用にConsumerを使う
          Consumer(builder: ((context, ref, child) {
            return Text(
              // 2-2. refを用いてstateの値を取り出す
              // ref.watchにプロバイダーを渡すとMyDataのstateの値が取得出来るため、文字列に加工して表示する
              ref.watch(_mydataProvider).toStringAsFixed(2),
              style: const TextStyle(fontSize: 100),
            );
          })),
          // 3-1. Slider用にConsumerを使う
          // データの受取部分を簡素に実装するために、Consumerを利用する
          Consumer(builder: (context, ref, child) {
            return Slider(
              // 3-2. refを用いてstateの値を取り出す
              // ref.watchにプロバイダーを渡すとMyDataのstateの値が取得できるため、スライダーの値にする
              value: ref.watch(_mydataProvider),
              // 3-3. changeStateで状態を変える
              // ref.readにプロバイダーのnotifierを渡すとMydataが取得できるため、changeStateメソッドを呼んで値を更新する
              onChanged: (value) =>
                  ref.read(_mydataProvider.notifier).changeState(value),
            );
          })
        ],
      ),
    );
  }
}
