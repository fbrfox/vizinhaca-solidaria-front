import 'dart:convert';
import 'dart:io';

extension FileExtensions on File {
  Future<String> toBase64() async {
    final bytes = await readAsBytes();
    return base64Encode(bytes);
  }
}
