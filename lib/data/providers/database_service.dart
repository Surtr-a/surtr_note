import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

export 'package:sembast/sembast.dart';
export 'package:sembast/sembast_io.dart';

class DatabaseService extends GetxService {
  Future<Database> init() async {
    return await databaseFactoryIo
        .openDatabase(join((await getTemporaryDirectory()).path, 'database', 'note.db'));
  }
}
