import 'file_export_web.dart' if (dart.library.io) 'file_export_desktop.dart';

abstract class FileExportUtil {
  Future<void> exportJson(String jsonData, String filename);
  
  static FileExportUtil get instance => createFileExportUtil();
} 
