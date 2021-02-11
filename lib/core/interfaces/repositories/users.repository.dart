import 'package:toggl_app/core/entities/user.dart';

abstract class IUsersRepository {
  Stream<User> login(String email, String password);
}