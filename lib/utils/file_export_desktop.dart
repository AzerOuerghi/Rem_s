import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'file_export.dart';

FileExportUtil createFileExportUtil() => DesktopFileExportUtil();

class DesktopFileExportUtil implements FileExportUtil {
  @override
  Future<void> exportJson(String jsonData, String filename) async {
    try {
      if (Platform.isAndroid) {
        // Request both storage permissions
        final status = await Permission.storage.request();
        final manageStatus = await Permission.manageExternalStorage.request();
        
        if (!status.isGranted && !manageStatus.isGranted) {
          throw Exception('Storage permission is required to save files. Please grant permission in Settings.');
        }

        // Try to access the Downloads directory
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final file = File('${directory.path}/$filename');
        await file.writeAsString(jsonData);
      } else {
        // For desktop platforms
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}${Platform.pathSeparator}$filename');
        await file.writeAsString(jsonData);
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        throw Exception('Storage permission denied. Please grant permission in your device settings and try again.');
      }
      throw Exception('Failed to save file: ${e.toString()}');
    }
  }
}
