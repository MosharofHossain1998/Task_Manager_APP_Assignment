import 'package:module_12/ui/widgets/task_item_card.dart';

class Urls{
  static const String baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registration = '$baseUrl/registration';
  static const String login = '$baseUrl/login';
  static const String createNewTask = '$baseUrl/createTask';
  static const String getTaskStatusCount = '$baseUrl/taskStatusCount';

  static String getNewTaskList = '$baseUrl/listTaskByStatus/${TaskStatus.New.name}';
  static String getInProgressTaskList = '$baseUrl/listTaskByStatus/${TaskStatus.Progress.name}';
  static String getCompletedTaskList = '$baseUrl/listTaskByStatus/${TaskStatus.Completed.name}';
  static String getCanclledTaskList = '$baseUrl/listTaskByStatus/${TaskStatus.Canclled.name}';

  static String getRecoveryVerifyEmail(String Email) => '$baseUrl/RecoverVerifyEmail/$Email';
  static String getRecoveryVerifyOTP(String Email,String otp) => '$baseUrl/RecoverVerifyOTP/$Email/$otp';
  static String postRecoverResetPass = '$baseUrl/RecoverResetPass';

  static String postProfileUpdate = '$baseUrl/profileUpdate';

  static String getUpdateTaskStatus(String taskId, String status) => '$baseUrl/updateTaskStatus/$taskId/$status';

}