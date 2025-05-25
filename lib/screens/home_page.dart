import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/colors/color.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/provider/data_provider.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/screens/add_work.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final provider = Provider.of<DataProvider>(context, listen: false);
    provider.saveUidToFirebase();
    provider.fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, model, _) {
        return Consumer<DataProvider>(builder: (context, dataModel, _) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(242, 211, 152, 9),
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'TASK TO-DO',
                style: TextStyle(color: bodyColor),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    model.signOut();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: redColor,
                  ),
                ),
              ],
              backgroundColor: const Color.fromRGBO(18, 38, 58, 5),
            ),
            body: dataModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : dataModel.isLoading == false && dataModel.tasks.isEmpty
                    ? const Center(
                        child: Text("No task to remind"),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 5,
                            crossAxisCount: 2,
                          ),
                          itemCount: dataModel.tasks.length,
                          itemBuilder: (BuildContext context, index) {
                            // final task = snapshot.data!.docs[index];
                            UserTask task = dataModel.tasks[index];
                            final title = task.title;
                            final work = task.task;
                            final documentId = task.id;
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            dataModel.deleteTask(documentId);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: redColor,
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            work,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(215, 133, 33, 9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AddWork()));
              },
              child: const Icon(Icons.add),
            ),
          );
        });
      },
    );
  }
}
