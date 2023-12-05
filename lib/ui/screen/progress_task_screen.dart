import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module_12/data_network_caller/models/task_count_summary_list_model.dart';
import 'package:module_12/data_network_caller/models/task_list_mode.dart';
import 'package:module_12/data_network_caller/network_caller.dart';
import 'package:module_12/data_network_caller/network_response.dart';
import 'package:module_12/data_network_caller/utility/url.dart';
import 'package:module_12/ui/widgets/profile_summary_card.dart';

import '../widgets/task_item_card.dart';

class ProgressTasksScreen extends StatefulWidget {
  const ProgressTasksScreen({super.key});

  @override
  State<ProgressTasksScreen> createState() => _ProgressTasksScreenState();
}

class _ProgressTasksScreenState extends State<ProgressTasksScreen> {

  bool getInProgressTask = false;
  TaskListModel taskListModel = TaskListModel();

  Future<void> getInProgressTaskList() async{
    getInProgressTask = true;
    if(mounted){
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.getInProgressTaskList);
    if(response.isSuccess){
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    getInProgressTask =false;
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getInProgressTaskList();
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
                  visible: getInProgressTask == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: RefreshIndicator(
                    onRefresh: getInProgressTaskList,
                    child: ListView.builder(
                        itemCount: taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: taskListModel.taskList![index],
                            onStatusChange: () {
                              getInProgressTaskList();
                            },
                            showProgress: (inProgress) {
                              getInProgressTask = inProgress;
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
