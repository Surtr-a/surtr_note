import 'package:get/get.dart';
import 'package:surtr_note/material/loading_dialog.dart';

extension GetExtension on GetInterface {
  loading() {
    dismiss();
    Get.dialog(LoadingDialog());
  }

  dismiss() {
    bool isOpen = Get.isDialogOpen ?? false;
    if (isOpen) {
      Get.back();
    }
  }
}