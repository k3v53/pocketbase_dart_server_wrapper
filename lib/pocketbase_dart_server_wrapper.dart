// ignore_for_file: public_member_api_docs, sort_constructors_first, curly_braces_in_flow_control_structures
import 'dart:io';

export 'package:pocketbase_dart_server_wrapper/pocketbase_dart_server_wrapper.dart'
    show PocketBaseWrapper;

class PocketBaseWrapper {
  /// The path where the executable is located
  String executablePath;

  /// The directory to serve static files, defaults to "pb_public"
  String? publicDir;

  /// The PocketBase data directory, defaults to "pb_data"
  String? dir;

  /// The env variable whose value of 32 character will be used as encryption key for the app settings, defaults to null
  String? encryptionEnv;

  /// Enable debug mode, aka. showing more detailed logs
  bool debug;
  // #region serve flags

  /// api HTTP server address, defaults to "127.0.0.1:8090"
  String? http;

  /// api HTTPS server address, (auto TLS via Let's Encrypt)
  String? https;

  /// CORS allowed domain origins list, defaults to ["*"]
  List<String>? origins;

  // #endregion

  /// The pocketbase process
  Process? process;

  /// A class that has the pocketbase flags to simplify the process of executing the server
  PocketBaseWrapper({
    required this.executablePath,
    this.publicDir,
    this.dir,
    this.encryptionEnv,
    this.debug = false,
    this.http,
    this.https,
    this.origins = const ["*"],
  });

  /// PocketBase serve command
  /// this command can receive [http], [https] and [origins] flags. These override this object flags
  serve({
    String? http,
    String? https,
    List<String>? origins,
  }) async {
    this.http = http;
    this.https = https;
    this.origins = origins;
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
    );
    process = result;
  }

  /// PocketBase migrate command
  /// Not Implemented Yet
  migrate() async {
    //TODO: Not implemented yet
    throw Exception('Migrate command is not implemented');
  }

  /// Listens to the process stdout stream and bypasses to this process stdout
  listenStdout() async {
    if (process == null) throw Exception("Pocketbase process is not running");
    await for (List<int> charCodes in process!.stdout)
      stdout.write(String.fromCharCodes(charCodes));
  }

  /// Listens to the process stderr stream and bypasses to this process stderr
  listenStderr() async {
    if (process == null) throw Exception("Pocketbase process is not running");
    await for (List<int> charCodes in process!.stderr)
      stderr.write(String.fromCharCodes(charCodes));
  }

  /// Kills the process if there's any
  dispose() async {
    if (process == null) return true;
    final result = process!.kill();
    return result;
  }
}
