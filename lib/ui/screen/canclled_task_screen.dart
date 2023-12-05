import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module_12/data_network_caller/models/task_count_summary_list_model.dart';
import 'package:module_12/data_network_caller/models/task_list_mode.dart';
import 'package:module_12/data_network_caller/network_caller.dart';
import 'package:module_12/data_network_caller/network_response.dart';
import 'package:module_12/data_network_caller/utility/url.dart';

import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class CancelledTasksScreen extends StatefulWidget {
  const CancelledTasksScreen({super.key});

  @override
  State<CancelledTasksScreen> createState() => _CancelledTasksScreenState();
}

class _CancelledTasksScreenState extends State<CancelledTasksScreen> {

  bool getCanclledTaskInProgress = false;
  TaskListModel taskListModel = TaskListModel();


  Future<void> getCanclledTaskList() async{
    getCanclledTaskInProgress = true;
    if(mounted){
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.getCanclledTaskList);
    if(response.isSuccess){
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    getCanclledTaskInProgress = false;
    if(mounted){
      setState(() {});
    }
  }


  @override
  void initState() {
    super.initState();
    getCanclledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const ProfileSummaryCard(),
              Expanded(
                child: Visibility(
                  visible: getCanclledTaskInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: RefreshIndicator(
                    onRefresh: getCanclledTaskList,
                    child: ListView.builder(
                        itemCount: taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: taskListModel.taskList![index],
                            onStatusChange: () {
                              getCanclledTaskList();
                            },
                            showProgress: (inProgress) {
                              getCanclledTaskInProgress = inProgress;
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
