import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module_12/data_network_caller/models/task_list_mode.dart';
import 'package:module_12/data_network_caller/network_caller.dart';
import 'package:module_12/data_network_caller/network_response.dart';
import 'package:module_12/data_network_caller/utility/url.dart';
import 'package:module_12/ui/screen/pin_verification_screen.dart';

import '../widgets/body_background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController _emailTEController = TextEditingController();
  TaskListModel taskListModel = TaskListModel();

  Future<void> getRecoveryEmailVerification() async {

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.getRecoveryVerifyEmail(_emailTEController.text));
    if(response.jsonResponse['status'] == 'success'){
      if(mounted){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PinVerificationScreen(Email: _emailTEController.text,),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getRecoveryEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text(
                  'Your Email Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'A 6 digit verification pin will send to your email address',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _emailTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        getRecoveryEmailVerification();
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      )),
                ),
                const SizedBox(
                  height: 48,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have An Account?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
