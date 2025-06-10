import 'dart:convert';
import 'dart:html' as html;
import 'binary_converter.dart';

class FileExportUtil {
  static final FileExportUtil instance = FileExportUtil._internal();
  FileExportUtil._internal();

  Future<void> exportJson(String jsonContent, String filename) async {
    final bytes = utf8.encode(jsonContent);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", filename)
      ..click();
    html.Url.revokeObjectUrl(url);

    // Also export binary version
    final jsonData = json.decode(jsonContent);
    final binaryData = BinaryConverter.convertJsonToBinary(jsonData);
    final binaryBlob = html.Blob([binaryData.buffer.asUint8List()]);
    final binaryUrl = html.Url.createObjectUrlFromBlob(binaryBlob);
    final binaryAnchor = html.AnchorElement(href: binaryUrl)
      ..setAttribute("download", filename.replaceAll('.json', '.bin'))
      ..click();
    html.Url.revokeObjectUrl(binaryUrl);
  }
}
