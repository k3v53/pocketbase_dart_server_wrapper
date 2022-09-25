import 'package:pocketbase_dart_server_wrapper/pocketbase_dart_server_wrapper.dart';

export 'package:pocketbase_dart_server_wrapper/pocketbase_dart_server_wrapper.dart'
    show PocketBaseWrapper;

void main() async {
  var pbServer = PocketBaseWrapper(executablePath: './bin/pocketbase.exe');
  pbServer.serve();
}
