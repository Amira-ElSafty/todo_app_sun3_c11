import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_c11/app_colors.dart';
import 'package:flutter_app_todo_sun_c11/home/settings/settings_tab.dart';
import 'package:flutter_app_todo_sun_c11/home/task_list/add_task_bottom_sheet.dart';
import 'package:flutter_app_todo_sun_c11/home/task_list/task_list_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: MediaQuery.of(context).size.height*0.2,
        title: Text(
          'To Do List',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Task_List'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            color: AppColors.primaryColor,
          ),
          Expanded(child: selectedIndex == 0 ? TaskListTab() : SettingsTab())
          // tabs[selectedIndex]
        ],
      ),
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskBottomSheet());
  }

// List<Widget> tabs = [TaskListTab(), SettingsTab()];
}
