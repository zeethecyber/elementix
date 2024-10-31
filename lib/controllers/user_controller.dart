import 'package:get/get.dart';

class UserController {
  final user = {}.obs;

  updateUser(var user) {
    user(user);
  }
}
