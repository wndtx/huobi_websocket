import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:archive/archive.dart';

main() async {
  final wsUrl = Uri.parse('wss://www.huobi.mw/-/s/pro/ws');
  var channel = WebSocketChannel.connect(wsUrl);

  var subMap = {
    'sub': 'market.btcusdt.kline.1min',
    'id': DateTime.now().millisecondsSinceEpoch,
  };

  channel.sink.add(jsonEncode(subMap));

  channel.stream.listen((message) {
    var msg = utf8.decode(GZipDecoder().decodeBytes(message.toList()));
    var data = jsonDecode(msg);
    if (data.containsKey('ping')) {
      channel.sink.add(jsonEncode({'pong': data['ping']}));
    } else {
      tickFetch(data);
    }
  });
}

void tickFetch(Map data) {
  if (data.containsKey('tick')) {
    print(data);
    // String ch = data['ch'];
    // var chList = ch.split('.');
    // var symbol = chList[1].split('usdt')[0].toUpperCase();
    // var tick = data['tick'];
  }
}
