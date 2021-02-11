import 'package:flutter/material.dart';
import 'package:toggl_app/data/persistence/shared-prefs-user-info.persistence.dart';
import 'package:toggl_app/presentation/welcome/welcome.screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                var success = await SharedPrefsUerInfoPersistence.getInstance()
                    .deleteUserInfo();
                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(),
                    ),
                  );
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Error! Try Again',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 14.0,
                          color: Colors.white
                        ),
                      ),
                    )
                  );
                }
              },
              child: Text(
                'LogOut',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
