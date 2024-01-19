import 'package:ecinema_watch_together/controlllers/loading_controller.dart';
import 'package:ecinema_watch_together/dal/user_dal.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/register_completion_screen_controller.dart';
import 'package:ecinema_watch_together/widgets/modals/snackbar_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameStepController extends GetxController {

  @override
  void onInit() {
    focusNode.requestFocus();
    textEditingController.text = _completionController.user.value['username']!;
    name.value = _completionController.user.value['username']!;
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.dispose();
    textEditingController.dispose();
    super.onClose();
  }

  final _completionController = Get.find<RegisterCompletionScreenController>();
  final focusNode = FocusNode();
  final textEditingController = TextEditingController();
  var loading = false.obs;
  var name = "".obs;
  
  bool get canNext => name.value.length > 1 && !loading.value;

  void onTextChanged(String text) {
    name.value = text;
    update();
  }

  void previous() => _completionController.previous();

  Future<void> next() async {
    if(!canNext) return;
    _startLoading();
    try {
      final hasUsernameTaken = await UserDal.instance.hasUsernameTaken(name.value);
      if(hasUsernameTaken) {
        showSnackbarModal(context: Get.context!, title: "Kullanıcı adı alınamadı", message: "Bu kullanıcı adı alınmış, lütfen başka bir kullanıcı adıyla tekrar deneyin.", duration: 3, actions: [SnackbarAction(onTap: () => Navigator.of(Get.context!).pop(), text: "Tamam")]);
      } else {
        _completionController.setUser({"username": name.value});
        _completionController.next();
      }
    } catch (err) {
      print("ERROR: $err");
      Get.snackbar("Hata", "Beklenmedik bir hata oluştu, lütfen tekrar deneyin", backgroundColor: Colors.white);
    } finally {
      _stopLoading();
    }
  }

  void _startLoading() {
    loading.value = true;
    LoadingController.showLoading();
    update();
  }

  void _stopLoading() {
    loading.value = false;
    LoadingController.hideLoading();
    update();
  }
}