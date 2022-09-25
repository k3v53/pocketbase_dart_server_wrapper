// ignore_for_file: public_member_api_docs, sort_constructors_first, curly_braces_in_flow_control_structures
import 'dart:io';

export 'package:pocketbase_dart_server_wrapper/pocketbase_dart_server_wrapper.dart'
    show PocketBaseWrapper;

class PocketBaseWrapper {
  String executablePath;
  String? publicDir;
  String? dir;
  String? http;
  String? https;
  String? origins;
  Process? process;
  PocketBaseWrapper({
    required this.executablePath,
    this.publicDir,
    this.dir,
    this.http,
    this.https,
    this.origins,
  });

  serve() async {
    Process result = await Process.start(
      executablePath,
      [
        'serve',
        if (http != null) '--http=$http',
        if (https != null) '--https=$https',
        if (origins != null) '--origins=$origins',
      ],
      // runInShell: true,
    );
    process = result;
  }

  migrate() async {
    //TODO: Not implemented yet
    throw Exception('Migrate command is not implemented');
  }

  listenStdin() async {
    if (process == null) throw Exception("Pocketbase process is not running");
    await for (List<int> charCodes in process!.stdout)
      stdout.write(String.fromCharCodes(charCodes));
    await for (List<int> charCodes in process!.stderr)
      stderr.write(String.fromCharCodes(charCodes));
  }
}
