import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/colors/color.dart';
import 'package:todo_app/provider/data_provider.dart';

class AddWork extends StatefulWidget {
  const AddWork({Key? key}) : super(key: key);

  @override
  State<AddWork> createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  // TextEditingController titleController = TextEditingController();
  // TextEditingController taskController = TextEditingController();
  // TextEditingController timeController = TextEditingController();
  // TextEditingController dateController = TextEditingController();
  //
  // // must call this function and make action on button
  //
  // final _formKey = GlobalKey<FormState>();
  // DateTime? selectedDate;
  // TimeOfDay? selectedTime;
  // String title = '';
  // String task = '';
  // DateTime? dateTime;
  //
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (pickedDate != null) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //       dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
  //       dateTime = DateTime(
  //         pickedDate.year,
  //         pickedDate.month,
  //         pickedDate.day,
  //         dateTime?.hour ?? 0,
  //         dateTime?.minute ?? 0,
  //       );
  //     });
  //   }
  // }
  //
  // Future<void> _selectTime(BuildContext context) async {
  //   TimeOfDay? _selectedTime;
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (pickedTime != null) {
  //     setState(() {
  //       selectedTime = pickedTime;
  //       timeController.text = selectedTime!.format(context);
  //       dateTime = DateTime(
  //         dateTime?.year ?? DateTime.now().year,
  //         dateTime?.month ?? DateTime.now().month,
  //         dateTime?.day ?? DateTime.now().day,
  //         pickedTime.hour,
  //         pickedTime.minute,
  //       );
  //     });
  //   }
  // }
  //
  // String? uid;
  //
  // void saveUidToFirebase() {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     uid = user.uid;
  //   }
  // }
  //
  // void addTask() async {
  //   try {
  //     await FirebaseFirestore.instance.collection("tasks").add({
  //       'title': titleController.text,
  //       'task': taskController.text,
  //       'time': timeController.text,
  //       'date': dateController.text,
  //       'uid': uid,
  //     }).then((value) {
  //       _scheduleNotification(value.id);
  //     });
  //   } catch (e) {
  //     print('Error adding task: $e');
  //   }
  // }
  //
  // Future<void> _scheduleNotification(String taskId) async {
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //       'task_reminder', 'Task Reminder',
  //       importance: Importance.high,
  //       priority: Priority.high,
  //       enableVibration: true);
  //   // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     // iOS: iOSPlatformChannelSpecifics,
  //   );
  //
  //   await flutterLocalNotificationsPlugin.schedule(
  //     taskId.hashCode,
  //     title,
  //     task,
  //     dateTime!,
  //     platformChannelSpecifics,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: bodyColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text(
            'Add Task',
            style: TextStyle(color: bodyColor),
          ),
          actions: const [
            Icon(Icons.save),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: model.formKey,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      // width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: model.titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          model.title = value!;
                        },
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.title,
                            color: Colors.white,
                          ),
                          hintText: 'Title',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      // width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: model.taskController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          model.task = value!;
                        },
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                          hintText: 'Task',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            // width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: appBarColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextField(
                              controller: model.timeController,
                              onTap: () {
                                model.selectTime(context);
                              },
                              onSubmitted: (value) {
                                print(value);
                                model.timeController.text = value;
                              },
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                icon: Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                ),
                                hintText: 'Remainder Time',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              model.selectTime(context);
                            },
                            icon: const Icon(Icons.timelapse))
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            // width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: appBarColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextField(
                              controller: model.dateController,
                              onTap: () {
                                model.selectDate(context);
                              },
                              onSubmitted: (value) {
                                model.dateController.text = value;
                                print(value);
                              },
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                icon: Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                ),
                                hintText: 'Remainder Date',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              model.selectDate(context);
                            },
                            icon: const Icon(Icons.date_range))
                      ],
                    ),

                    // if (time != null) Text(time!),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      // width: MediaQuery..width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: ElevatedButton(
                          onPressed: () {
                            if (model.formKey.currentState!.validate()) {
                              model.formKey.currentState!.save();
                              if (model.dateTime != null) {
                                model.addTask();
                                Navigator.pop(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Please select date and time'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              // primary: buttonColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
