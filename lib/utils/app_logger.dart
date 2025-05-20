import 'package:logging/logging.dart';

class AppLogger {
  static void init({Level level = Level.ALL}) {
    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: ${record.time}: ${record.loggerName}; ${record.message}',
      );
      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('StackTrace: ${record.stackTrace}');
      }
    });
  }

  static Logger getLogger(String name) {
    return Logger(name);
  }
}
