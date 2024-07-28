import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_c11/firebase_utils.dart';
import 'package:flutter_app_todo_sun_c11/model/task.dart';
import 'package:flutter_app_todo_sun_c11/provider/list_provider.dart';
import 'package:provider/provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Add new task',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    onChanged: (text) {
                      title = text;
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please enter task title'; // invalid
                      }
                      return null;

                      /// valid
                    },
                    decoration: InputDecoration(hintText: 'Enter task title'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (text) {
                      description = text;
                    },
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Please enter task description'; // invalid
                      }
                      return null;

                      /// valid
                    },
                    decoration:
                    InputDecoration(hintText: 'Enter task Description'),
                    maxLines: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Select Date',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        showCalendar();
                      },
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/'
                            '${selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(
                        'Add',
                        style: Theme.of(context).textTheme.titleLarge,
                      ))
                ],
              )),
        ],
      ),
    );
  }

  void showCalendar() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));

    /// DateTime     DateTime?
    // if(chosenDate != null){
    //   selectedDate = chosenDate ;
    // }
    selectedDate = chosenDate ?? selectedDate;
    setState(() {});
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      /// add task
      Task task = Task(
        title: title,
        description: description,
        dateTime: selectedDate,
      );
      FirebaseUtils.addTaskToFireStore(task).timeout(Duration(seconds: 1),
          onTimeout: () {
            print('Task added successfully');
        listProvider.getAllTasksFromFireStore();
        Navigator.pop(context);
      });
    }
  }
}
