import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:todo_app/colors/text_color.dart';
import 'package:todo_app/models/task_model.dart';

class DataProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  // must call this function and make action on button

  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String title = '';
  String task = '';
  DateTime? dateTime;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedDate = pickedDate;
      dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      dateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        dateTime?.hour ?? 0,
        dateTime?.minute ?? 0,
      );
      notifyListeners();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? _selectedTime;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      selectedTime = pickedTime;
      timeController.text = selectedTime!.format(context);
      dateTime = DateTime(
        dateTime?.year ?? DateTime.now().year,
        dateTime?.month ?? DateTime.now().month,
        dateTime?.day ?? DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );
      notifyListeners();
    }
  }

  String? uid;

  void saveUidToFirebase() async {
    debugPrint("🚨🚨🚨vm uri ${await getVmUri()}".blink);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      debugPrint("🚨🚨🚨uid after fetch ${uid}");
    }
  }

  Future<Uri?> getVmUri() async {
    ServiceProtocolInfo serviceProtocolInfo = await Service.getInfo();
    return serviceProtocolInfo.serverUri;
  }

  emptyFields() {
    timeController.clear();
    taskController.clear();
    timeController.clear();
    dateController.clear();
  }

  void addTask() async {
    try {
      debugPrint("🚨🚨🚨 ${uid}");
      await FirebaseFirestore.instance
          .collection(
            "tasks",
          )
          .doc(uid)
          .collection("userTasks")
          .add({
        'title': titleController.text,
        'task': taskController.text,
        'time': timeController.text,
        'date': dateController.text,
        'uid': uid,
      }).then((value) {
        _scheduleNotification(value.id);
      });
      emptyFields();
      fetch();
      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  List<UserTask> _tasks = [];

  List<UserTask> get tasks => _tasks;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TaskProvider() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _tasks = [];
      _isLoading = false;
      _errorMessage = "User not logged in";
      notifyListeners();
      return;
    }

    final String uid = user.uid;
    fetch();
    String text = "hola";
    debugPrint('\x1B[31m$text\x1B[0m');
    _isLoading = false;
    // notifyListeners();
  }

  void fetch() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(uid)
          .collection('userTasks')
          .orderBy('date')
          .get();

      _tasks = snapshot.docs.map((doc) => UserTask.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching tasks: $error');
      _errorMessage = 'Failed to fetch tasks: $error';
    }
  }

  void deleteTask(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("tasks")
          .doc(uid)
          .collection("userTasks")
          .doc(documentId)
          .delete();
      fetch();
      notifyListeners();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> _scheduleNotification(String taskId) async {
    // if (await Permission.scheduleExactAlarm.isDenied) {
    //   final status = await Permission.scheduleExactAlarm.request();
    //   if (status.isDenied) {
    //     print('Exact alarm permission denied by user.');
    //     // Show error to user
    //     return;
    //   }
    // }
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final bool? canScheduleExactAlarms =
          await androidImplementation.canScheduleExactNotifications();
      if (!canScheduleExactAlarms!) {
        print('Exact alarms are restricted by the system.');
        // You can inform the user or open settings for them to enable
        // androidImplementation.openAlarmSettings(); // This might be an option
      }
    }
    tz.initializeTimeZones();
    DateTime localDateTime = DateTime.now().add(const Duration(minutes: 1));
// Your existing DateTime object

// Specify the target time zone (e.g., 'America/New_York', 'Europe/London', 'Asia/Kolkata')
    String timeZoneName = 'Asia/Kolkata';
    final Location kolkata = getLocation(timeZoneName);

// Convert the DateTime to TZDateTime
    TZDateTime tzDateTime = TZDateTime.from(localDateTime, kolkata);

    print('Local DateTime: $localDateTime');
    print('TZDateTime in $timeZoneName: $tzDateTime');
    try {
      // Assuming you have a DateTime called notificationDateTime
      // that combines date and time
      print(
          'Scheduling notification for task: $taskId at: ${dateTime.toString()}');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        taskId.hashCode, // Use taskId.hashCode for unique ID
        'Task Reminder',
        'Your task: $taskId',
        tzDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_reminder',
            'Task Reminder',
            channelDescription: 'Description for task reminders',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      print('Notification scheduled for task: $taskId');
    } catch (e) {
      print('Error scheduling notification: $e');
      // Show error to user
    }
  }
}
