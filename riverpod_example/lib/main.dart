import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      body: const MyContents(),
    );
  }
}

class MyContents extends HookConsumerWidget {
  const MyContents({Key? key}) : super(key: key);

  // HookConsumerWidgetを使うことでbuildメソッドでrefが使えるようになる
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watchでプロバイダーにアクセスしスライダー値を管理
    double slideValue = ref.watch(_mydataProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // slideValueでstate(カウンタ値)を取得し、使えるので、Consumerが不要になる
        Text(
          slideValue.toStringAsFixed(2),
          style: const TextStyle(fontSize: 100),
        ),
        Slider(
          value: slideValue,
          onChanged: (value) =>
              ref.read(_mydataProvider.notifier).changeState(value),
        )
      ],
    );
  }
}
