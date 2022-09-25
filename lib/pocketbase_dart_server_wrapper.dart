// ignore_for_file: public_member_api_docs, sort_constructors_first, curly_braces_in_flow_control_structures
import 'dart:io';

export 'package:pocketbase_dart_server_wrapper/pocketbase_dart_server_wrapper.dart'
    show PocketBaseWrapper;

class PocketBaseWrapper {
  String executablePath;
  String? publicDir;
  String? dir;
  String? encryptionEnv;
  bool debug;
  // #region serve flags

  String? http;
  String? https;
  String? origins;

  // #endregion

  Process? process;
  PocketBaseWrapper({
    required this.executablePath,
    this.publicDir,
    this.dir,
    this.encryptionEnv,
    this.debug = false,
    this.http,
    this.https,
    this.origins,
  });

  serve() async {
    Process result = await Process.start(
      executablePath,
      [
        'serve',
        if (publicDir != null) '--publicDir=$publicDir',
        if (dir != null) '--dir=$dir',
        if (encryptionEnv != null) '--encryptionEnv=$encryptionEnv',
        if (debug) '--debug',
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

  listenStdout() async {
    if (process == null) throw Exception("Pocketbase process is not running");
    await for (List<int> charCodes in process!.stdout)
      stdout.write(String.fromCharCodes(charCodes));
    await for (List<int> charCodes in process!.stderr)
      stderr.write(String.fromCharCodes(charCodes));
  }

  dispose() async {
    if (process == null) return true;
    final result = process!.kill();
    // process = null;
    return result;
  }
}
