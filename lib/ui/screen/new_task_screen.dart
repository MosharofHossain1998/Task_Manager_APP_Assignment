import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:module_12/data_network_caller/models/task_count_summary_list_model.dart';
import 'package:module_12/data_network_caller/models/task_list_mode.dart';
import 'package:module_12/data_network_caller/network_caller.dart';
import 'package:module_12/data_network_caller/network_response.dart';
import 'package:module_12/ui/screen/add_new_task_screen.dart';

import '../../data_network_caller/models/task_count.dart';
import '../../data_network_caller/models/task_list_mode.dart';
import '../../data_network_caller/utility/url.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_item_card.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  bool getNewTaskInProgress = false;
  bool getTaskCountSummaryListInProgress = false;

  TaskListModel taskListModel = TaskListModel();
  TaskCountSummaryListModel taskCountSummaryList = TaskCountSummaryListModel();

  Future<void> getNewTaskList() async {
    getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getNewTaskList);
    log(response.statusCode.toString());
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getNewTaskCountSummaryList() async {
    getTaskCountSummaryListInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    log(response.statusCode.toString());
    if (response.isSuccess) {
      taskCountSummaryList =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
    }

    getTaskCountSummaryListInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getNewTaskCountSummaryList();
    getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewTaskScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ProfileSummaryCard(),
              
              Visibility(
                visible: getTaskCountSummaryListInProgress == false &&
                  (taskCountSummaryList.taskCountList?.isNotEmpty ?? false),
                replacement: const LinearProgressIndicator(),
                child: SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskCountSummaryList.taskCountList?.length ?? 0,
                    itemBuilder: (context, index) {
                      TaskCount taskCount = taskCountSummaryList.taskCountList![index];
                     return FittedBox(
                       child: SummaryCard(
                          count: taskCount.sum.toString(),
                          title: taskCount.sId ?? '',
                        ),
                     );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: getNewTaskInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: RefreshIndicator(
                    onRefresh: getNewTaskList,
                    child: ListView.builder(
                        itemCount: taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: taskListModel.taskList![index],
                            onStatusChange: () {
                              getNewTaskList();
                              getNewTaskCountSummaryList();
                            },
                            showProgress: (inProgress) {
                              getNewTaskInProgress = inProgress;
                              if(mounted){
                                setState(() {});
                              }
                            },
                          );
                        }),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
