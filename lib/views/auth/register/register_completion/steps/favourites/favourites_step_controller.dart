import 'package:ecinema_watch_together/utils/app/app_constants.dart';
import 'package:ecinema_watch_together/views/auth/register/register_completion/register_completion_screen_controller.dart';
import 'package:get/get.dart';

class FavouritesStepController extends GetxController {

  @override
  void onInit() {
    favourites.value = _completionController.user.value['favourites'];
    super.onInit();
  }

  final _completionController = Get.find<RegisterCompletionScreenController>();
  final movieCategories = AppConstants.movieCategories;
  var favourites = Rx<List<String>>([]);
  var loading = false.obs;
  
  bool get canNext => favourites.value.length >= 3 && !loading.value;

  void updateFavourites(String category) {
    if(favourites.value.contains(category)) {
      favourites.value.remove(category);
    } else {
      if(favourites.value.length >= 3) return;
      favourites.value.add(category);
    }
    _completionController.setUser({"favourites": favourites.value});
    update();
  }

  void previous() => _completionController.previous();
  
  void next() {
    if(!canNext) return;
    _completionController.next();
  }
}