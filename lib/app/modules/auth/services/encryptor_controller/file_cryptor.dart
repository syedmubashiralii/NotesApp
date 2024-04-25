part of 'encryptor_controller.dart';

/// FileCryptor for encryption and decryption files.
class _FileCryptor extends BaseFileCryptor {
  /// [key] is using for encrypt and decrypt given file
  final String key;

  /// [iv] is Initialization vector encryption times
  final String iv;

  /// [IV] private instance for encryption and decryption
  final IV _iv;

  /// [Key] private instance for encryption and decryption
  final Key _key;

  /// [dir] working directory
  final String dir;

  /// [useCompress] for compressing file as GZip.
  final bool useCompress;

  /// [key] is using for encrypt and decrypt given file
  ///
  /// [iv] is Initialization vector encryption times
  ///
  /// [dir] working directory
  ///
  /// [useCompress] for compressing file as GZip.
  _FileCryptor({
    required this.key,
    required this.iv,
    required this.dir,
    this.useCompress = false,
  })  : assert(key.length == 16, "key length must be 16"),
        this._iv = IV.fromUtf8(iv),
        this._key = Key.fromUtf8(key);

  /// Get current absolute working directory
  String getCurrentDir() => p.absolute(dir);

  @override
  Future<File> decryptAES({
    String? inputFile,
    String? outputFile,
    bool? useCompress,
  }) async {
    bool _useCompress = useCompress == null ? this.useCompress : useCompress;
    File _inputFile = File(p.join(dir, inputFile));
    File _outputFile = File(p.join(dir, outputFile));

    bool _outputFileExists = await _outputFile.exists();
    bool _inputFileExists = await _inputFile.exists();

    if (!_outputFileExists) {
      await _outputFile.create();
    }

    if (!_inputFileExists) {
      throw Exception("Input file not found.");
    }

    final _fileContents = _inputFile.readAsBytesSync();

    var compressedContent;

    if (_useCompress) {
      compressedContent = GZipDecoder().decodeBytes(_fileContents.toList());
    }

    final Encrypter _encrypter = Encrypter(AES(_key));

    final _encryptedFile =
        Encrypted((_useCompress ? compressedContent : _fileContents));
    final _decryptedFile = _encrypter.decryptBytes(_encryptedFile, iv: _iv);

    return await _outputFile.writeAsBytes(_decryptedFile);
  }

  @override
  Future<File> encryptAES({
    String? inputFile,
    String? outputFile,
    bool? useCompress,
  }) async {
    bool _useCompress = useCompress == null ? this.useCompress : useCompress;
    File _inputFile = File(p.join(dir, inputFile));
    File _outputFile = File(p.join(dir, outputFile));

    bool _outputFileExists = await _outputFile.exists();
    bool _inputFileExists = await _inputFile.exists();

    if (!_outputFileExists) {
      await _outputFile.create();
    }

    if (!_inputFileExists) {
      throw Exception("Input file not found.");
    }

    final _fileContents = _inputFile.readAsBytesSync();

    final Encrypter _encrypter = Encrypter(AES(_key));

    final Encrypted _encrypted = _encrypter.encryptBytes(
      _fileContents,
      iv: _iv,
    );

    var compressedContent;

    if (_useCompress) {
      compressedContent = GZipEncoder().encode(_encrypted.bytes.toList())!;
    }

    File _encryptedFile = await _outputFile
        .writeAsBytes(_useCompress ? compressedContent : _encrypted.bytes);

    return _encryptedFile;
  }

//   ******************  Encryption decryption using SALSA ***************

  @override
  Future<String> decryptSalsa20({
    String? inputFile,
    String? outputFile,
    bool? useCompress,
  }) async {
    bool _useCompress = useCompress == null ? this.useCompress : useCompress;
    File _inputFile = File(p.join(dir, inputFile));
    // File _outputFile = File(p.join(dir, outputFile));

    // bool _outputFileExists = await _outputFile.exists();
    bool _inputFileExists = await _inputFile.exists();

    // if (!_outputFileExists) {
    //   await _outputFile.create();
    // }

    if (!_inputFileExists) {
      throw Exception("Input file not found.");
    }

    final _fileContents = _inputFile.readAsBytesSync();

    var compressedContent;

    if (_useCompress) {
      compressedContent = GZipDecoder().decodeBytes(_fileContents.toList());
    }

    final Encrypter _encrypter = Encrypter(Salsa20(_key));

    final Encrypted _encryptedFile =
        Encrypted((_useCompress ? compressedContent : _fileContents));
    // final _decryptedFile = _encrypter.decryptBytes(_encryptedFile, iv: _iv);
    final String _decryptedFileData =
        _encrypter.decrypt(_encryptedFile, iv: _iv);

    return _decryptedFileData; //await _outputFile.writeAsBytes(_decryptedFile);
  }

  @override
  Future<File> encryptSalsa20({
    String? inputFile,
    String? dataInStringForm,
    String? outputFile,
    bool? useCompress,
  }) async {
    bool _useCompress = useCompress == null ? this.useCompress : useCompress;
    // File _inputFile = File(p.join(dir, inputFile));
    File _outputFile = File(p.join(dir, outputFile));

    bool _outputFileExists = await _outputFile.exists();
    // bool _inputFileExists = await _inputFile.exists();
    logInfo("_outputFileExists: $_outputFileExists");
    // if (!_outputFileExists) {
    //   await _outputFile.create();
    // }
    if (!_outputFileExists) {
      // Ensure that the parent directories are created
      await _outputFile.parent.create(recursive: true);
      await _outputFile.create();
    }
    // if (!_inputFileExists) {
    //   throw Exception("Input file not found.");
    // }

    // final _fileContents = _inputFile.readAsBytesSync();

    final Encrypter _encrypter = Encrypter(Salsa20(_key));

    Encrypted _encrypted = _encrypter.encrypt(
      dataInStringForm!,
      iv: _iv,
    );

    // final Encrypted _encrypted = _encrypter.encryptBytes(
    //   _fileContents,
    //   iv: _iv,
    // );

    var compressedContent;

    if (_useCompress) {
      compressedContent = GZipEncoder().encode(_encrypted.bytes.toList())!;
    }

    File _encryptedFile = await _outputFile
        .writeAsBytes(_useCompress ? compressedContent : _encrypted.bytes);

    return _encryptedFile;
  }

  @override
  Future<String> encryptStringWithSalsa({
    required String dataToEncrypt,
  }) async {
    try {
      final Encrypter _encrypter = Encrypter(Salsa20(_key));

      Encrypted _encrypted = _encrypter.encrypt(
        dataToEncrypt,
        iv: _iv,
      );

      var compressedContent = utf8.encode(_encrypted.base64);

      return _encrypted.base64;
    } catch (e) {
      logError("Error in encryptStringWithSalsa: $e");
      rethrow;
    }
  }

  @override
  Future<String> decryptStringWithSalsa({
    required String dataToDecrypt,
  }) async {
    try {
      var compressedContent = Uint8List.fromList(base64.decode(dataToDecrypt));
      logInfo("decryptStringWithSalsa _key: ${_key.bytes}");
      logInfo("_iv: $_iv");
      final Encrypter _encrypter = Encrypter(Salsa20(_key));

      final Encrypted _encryptedFile = Encrypted(compressedContent);
      final String _decryptedFileData =
          _encrypter.decrypt(_encryptedFile, iv: _iv);

      return _decryptedFileData;
    } catch (e) {
      logError("Error in decryptStringWithSalsa: $e");
      rethrow;
    }
  }
//   ****************** SALSA ended ***************

// @override
// Uint8List decryptUint8List({Uint8List? data, bool? useCompress}) {
//   bool _useCompress = useCompress == null ? this.useCompress : useCompress;
//   if (data == null) {
//     throw Exception("data cannot be null");
//   }
//   final Encrypter _encrypter = Encrypter(AES(_key));
//
//   List<int>? compressedContent;
//
//   if (_useCompress) {
//     compressedContent = GZipDecoder().decodeBytes(data);
//   }
//
//   final Encrypted _encrypted =
//   Encrypted(_useCompress ? Uint8List.fromList(compressedContent!) : data);
//   final _decryptedData = _encrypter.decryptBytes(_encrypted, iv: _iv);
//
//   return Uint8List.fromList(_decryptedData);
// }
//
// @override
// Uint8List encryptUint8List({Uint8List? data, bool? useCompress}) {
//   bool _useCompress = useCompress == null ? this.useCompress : useCompress;
//   if (data == null) {
//     throw Exception("data cannot be null");
//   }
//   final Encrypter _encrypter = Encrypter(AES(_key));
//   final Encrypted _encrypted =
//   _encrypter.encrypt(String.fromCharCodes(data), iv: _iv);
//
//   List<int>? compressedContent;
//
//   if (_useCompress) {
//     compressedContent = GZipEncoder().encode(_encrypted.bytes.toList())!;
//   }
//
//   return _useCompress
//       ? Uint8List.fromList(compressedContent!)
//       : _encrypted.bytes;
// }
}
