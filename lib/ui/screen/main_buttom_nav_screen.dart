import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module_12/ui/screen/canclled_task_screen.dart';
import 'package:module_12/ui/screen/completed_task_screen.dart';
import 'package:module_12/ui/screen/new_task_screen.dart';
import 'package:module_12/ui/screen/progress_task_screen.dart';

class MainButtomNavScreen extends StatefulWidget {
  const MainButtomNavScreen({super.key});

  @override
  State<MainButtomNavScreen> createState() => _MainButtomNavScreenState();
}

class _MainButtomNavScreenState extends State<MainButtomNavScreen> {

  int _selectedIndex = 0;

  final List<Widget> _screen = const[
    NewTasksScreen(),
    ProgressTasksScreen(),
    CompletedTasksScreen(),
    CancelledTasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index){
          _selectedIndex = index;
          setState(() {});
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_outlined),label: 'New'),
          BottomNavigationBarItem(icon: Icon(Icons.rocket_launch_sharp),label: 'In Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.done),label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.close),label: 'Canclled'),
        ],
      ),
    );
  }
}
