import 'package:cloud_firestore/cloud_firestore.dart';

class Logger {
  static Future<void> logError(String message) async {
    await FirebaseFirestore.instance.collection('logs').add({"message": message});
  }
}