import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';

import '../widgets/notification_templates/submission_assignment_notification_template.dart';

class Notification {
  final String title;
  final String body;
  final String user;
  final DateTime createdAt;
  final String id;
  final NotificationTemplate? template;
  final Map<String, dynamic>? templateData;
  bool isRead;

  Notification({
    required this.title,
    required this.body,
    required this.user,
    required this.createdAt,
    required this.isRead,
    required this.id,
    this.template,
    this.templateData,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'user': user,
    'createdAt': createdAt,
    'isRead': isRead,
    'id': id,
    'template': template?.name,
    'templateData': templateData,
  };

  factory Notification.fromMap(Map data) {
    try {
      return Notification(
        title: data['title'],
        body: data['body'],
        user: data['user'],
        createdAt: DateTime.fromMicrosecondsSinceEpoch((data['createdAt'] as Timestamp).microsecondsSinceEpoch),
        isRead: data['isRead'],
        id: data['id'],
        template: getNotificaitonTemplateFromString(data['template']),
        templateData: data['templateData'],
      );
    } catch (e) {
      print('Error converting Notification from JSON: ${e.toString()}');
      rethrow;
    }
  }

  Future<String?> upload() async {
    try {
      await FirebaseFirestore.instance.collection('notifications').doc(id).set(toJson());
    } catch (error) {
      return error.toString();
    }
    return null;
  }

  Future<String?> delete() async {
    try {
      await FirebaseFirestore.instance.collection('notifications').doc(id).delete();
    } catch (error) {
      return error.toString();
    }
    return null;
  }

  Widget? getWidgetFromNotificationTemplate() {
    try {
      switch (template) {
        case NotificationTemplate.submissionAssignment:
          return SubmissionAssignmentNotificationTemplate(
            submissionId: templateData!['submissionId']!,
            submissionUserName: templateData!['submissionUserName']!,
          );
        case null:
        // TODO: Handle this case.
          throw UnimplementedError();
      }
    } catch (e) {
      print('Error getting widget from notification template: ${e.toString()}');
      return null;
    }
  }
}

enum NotificationTemplate {
  submissionAssignment,
}

NotificationTemplate? getNotificaitonTemplateFromString(String? value) {
  print('Debugging Step: Converting from template string: $value');
  try {
    switch(value) {
      case 'submissionAssignment':
        return NotificationTemplate.submissionAssignment;
    }
  } catch (e) {
    print('Debugging Step: Error converting difficulty from string: ${e.toString()}');
  }
  return null;
}