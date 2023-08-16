import "dart:math" as math;
import 'dart:async';

// Generatorクラス
// データの生成を担当する
class Generator {
  int currentTime = 0;
  int keikaTime = 10;
  // コンストラクタでint型のStreamを受け取る
  Generator(
    StreamController<int> intStream,
    StreamController<String> timerStream,
  ) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime++;
      int displayTime = keikaTime - currentTime;
      // 設定した時間経過した際の処理
      if (displayTime < 0) {
        // currentTimeを0に初期化
        currentTime = 0;
        // ランダムな数値を生成
        int data = math.Random().nextInt(100);
        intStream.sink.add(data);
      }
      timerStream.sink.add((keikaTime - currentTime).toString());
    });
  }
}

// Coordinatorクラス
// データの加工を担当する
class Coordinator {
  // コンストラクタでint型のStreamとString型のStreamを受け取る
  Coordinator(
      StreamController<int> intStream, StreamController<String> stringStream) {
    // 流れてきたものをintからStringにする
    intStream.stream.listen((data) async {
      String newData = data.toString();
      print("Coordinatorが$data(数値)から$newData(文字列)に変換したよ");
      stringStream.sink.add(newData);
    });
  }
}

// Consumerクラス
// データの利用を担当する
class Consumer {
  // コンストラクタでString型のStreamを受け取る
  Consumer(StreamController<String> stringStream) {
    // Streamをlistenしてデータが来たらターミナルに表示する
    stringStream.stream.listen((data) async {
      print("Consumerが$dataを使ったよ");
    });
  }
}
