import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:korda/core/utils/notifications.dart';

// check connectivity before performing a particular function
connectivityChecker({required Function action}) async {
  Connectivity connectivity = Connectivity();
  ConnectivityResult connectivityResult =
      await connectivity.checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    // alert user if there is no connectivity
    errorNotification('You have no internet access');
  } else {
    // function if there is connectivity
    action();
  }
}
