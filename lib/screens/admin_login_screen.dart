import 'package:dodecathlon/screens/admin_home_screen.dart';
import 'package:flutter/Material.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => AdminHomeScreen())
                );
              },
              child: Text('Admin Login Screen')
          ),
      )
    );
  }
}