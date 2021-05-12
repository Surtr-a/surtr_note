import 'package:get/get.dart';
import 'package:surtr_note/modules/detail/detail_page.dart';
import 'package:surtr_note/modules/history/history_binding.dart';
import 'package:surtr_note/modules/history/history_page.dart';
import 'package:surtr_note/modules/home/home_binding.dart';
import 'package:surtr_note/modules/home/home_page.dart';
import 'package:surtr_note/modules/input/input_binding.dart';
import 'package:surtr_note/modules/input/input_page.dart';
import 'package:surtr_note/modules/record/record_binding.dart';
import 'package:surtr_note/modules/record/record_page.dart';
import 'package:surtr_note/modules/search/search_binding.dart';
import 'package:surtr_note/modules/search/search_page.dart';
import 'package:surtr_note/routes/app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(name: Routes.INPUT, page: () => InputPage(), binding: InputBinding()),
    GetPage(name: Routes.RECORD, page: () => RecordPage(), binding: RecordBinding()),
    GetPage(name: Routes.HISTORY, page: () => HistoryPage(), binding: HistoryBinding()),
    GetPage(name: Routes.DETAIL, page: () => DetailPage()),
    GetPage(name: Routes.SEARCH, page: () => SearchPage(), binding: SearchBinding()),
  ];
}
