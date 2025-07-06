import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef MessageHandler = void Function(dynamic message);
typedef ErrorHandler = void Function(dynamic error);

class WebSocketService {
  final String url;
  late final WebSocketChannel _channel;
  MessageHandler? onMessage;
  ErrorHandler? onError;

  bool _isConnected = false;

  WebSocketService(this.url);

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _isConnected = true;

    _channel.stream.listen(
      (message) {
        if (onMessage != null) onMessage!(message);
      },
      onError: (error) {
        _isConnected = false;
        if (onError != null) onError!(error);
      },
      onDone: () {
        _isConnected = false;
        print("WebSocket closed.");
      },
    );
  }

  void send(dynamic data) {
    if (_isConnected) {
      _channel.sink.add(data);
    } else {
      print("WebSocket not connected. Message not sent.");
    }
  }

  void close() {
    _channel.sink.close(status.normalClosure);
    _isConnected = false;
  }

  bool get isConnected => _isConnected;
}
