import 'package:pocketbase_dart_server_wrapper/pocketbase_dart_server_wrapper.dart';

void main(List<String> arguments) async {
  final pocketBaseServer = PocketBaseWrapper(
    // You need to specify your pocketbase executable is
    executablePath: './pocketbase.exe',
  );
  // Run serve command
  await pocketBaseServer.serve();
  // Create a future that completes after 5 seconds
  Future.delayed(Duration(seconds: 5)).then((e) =>
      // Close the server after future completes
      pocketBaseServer.dispose());
  // Listen to stdout
  await pocketBaseServer.listenStdout();
}
