import 'dart:async';
import 'dart:convert';
import 'package:toggl_app/core/entities/user.dart';
import 'package:toggl_app/core/interfaces/repositories/users.repository.dart';
import 'package:toggl_app/data/persistence/shared-prefs-user-info.persistence.dart';
import 'package:toggl_app/data/web/web-client.dart';

class UsersWebRepository implements IUsersRepository {
  @override
  Stream<User> login(String email, String password) {
    if (email == '' || password == '') return null;

    WebClient client = WebClient(tokenProvider: SharedPrefsUerInfoPersistence.getInstance());

    StreamController<User> controller = StreamController<User>();

    // construct authorization header according to toggl API v8 specification.
    String credentials = '$email:$password';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    client.addHeader('Authorization', 'Basic $encoded');
    client.request('me', HttpMethod.GET, queries: {'with_related_data': 'true'}).then((response) {
      if(response['status'] == 'unauthorized') {
        throw Exception();
      }
      User user = User(response['data']['fullname'], response['data']['api_token'], response['data']['email']);
      controller.add(user);
      controller.close();
    }).catchError((e) {
      print(e);
      controller.close();
    });
    return controller.stream;
  }
}
