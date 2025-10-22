import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountManagementScreen extends ConsumerStatefulWidget {
  AccountManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ThemeSelectionScreen();
  }
}

class _ThemeSelectionScreen extends ConsumerState<AccountManagementScreen> {
  String email = FirebaseAuth.instance.currentUser!.email!;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Management'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(title: Text('Email'), subtitle: Text(email),),
          ],
        ),
      ),
    );
  }
}