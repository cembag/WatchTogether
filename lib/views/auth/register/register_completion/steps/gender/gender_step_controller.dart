import 'package:ecinema_watch_together/views/auth/register/register_completion/register_completion_screen_controller.dart';
import 'package:get/get.dart';

class GenderStepController extends GetxController {

  @override
  void onInit() {
    selectedGender.value = _completionController.user.value['gender'];
    super.onInit();
  }
  var loading = false.obs;
  final _completionController = Get.find<RegisterCompletionScreenController>();
  var selectedGender = Rx<String?>(null);
  
  bool get canNext => selectedGender.value != null && !loading.value;

  void setGender(String gender) {
    selectedGender.value = gender;
    update();
  }

  void previous() => _completionController.previous();

  Future<void> next() async {
    if(!canNext) return;
    _completionController.setUser({"gender": selectedGender.value});
    _completionController.next();
  }
}