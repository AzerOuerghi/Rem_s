import 'dart:convert';
import 'dart:html' as html;
import 'file_export.dart';

FileExportUtil createFileExportUtil() => WebFileExportUtil();

class WebFileExportUtil implements FileExportUtil {
  @override
  Future<void> exportJson(String jsonData, String filename) async {
    final bytes = utf8.encode(jsonData);
    final blob = html.Blob([bytes], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..download = filename
      ..style.display = 'none';
      
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }
}
