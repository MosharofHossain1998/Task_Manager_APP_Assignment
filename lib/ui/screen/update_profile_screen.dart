
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:module_12/data_network_caller/models/user_model.dart';
import 'package:module_12/ui/controllers/authentication_controller.dart';
import 'package:module_12/ui/screen/login_screen.dart';
import 'package:module_12/ui/widgets/body_background.dart';
import 'package:module_12/ui/widgets/profile_summary_card.dart';
import 'package:module_12/ui/widgets/snackbar_massage.dart';

import '../../data_network_caller/network_caller.dart';
import '../../data_network_caller/network_response.dart';
import '../../data_network_caller/utility/url.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _profileUpdateInProgress = false;

  XFile? photo;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthenticationController.user?.email ?? '';
    _firstNameTEController.text = AuthenticationController.user?.firstName ?? '';
    _lastNameTEController.text = AuthenticationController.user?.lastName ?? '';
    _phoneNumberTEController.text = AuthenticationController.user?.mobile ?? '';
  }

  Future<void> updateProfile() async{
    _profileUpdateInProgress = true;
    if(mounted){
      setState(() {});
    }
    String? photoBase64;
    Map<String , dynamic> inputData = {
      "email": _emailTEController.text,
      "firstName": _firstNameTEController.text,
      "lastName": _lastNameTEController.text,
      "mobile": _phoneNumberTEController.text,
    };

    if(_passwordTEController.text.isNotEmpty){
      inputData["password"] = _passwordTEController.text;
    }

    if(photo != null){
      List<int> imageBytes = await photo!.readAsBytes();
      photoBase64 = base64Encode(imageBytes);
      inputData['photo'] = photoBase64;
    }

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.postProfileUpdate,requestBody: inputData);

    _profileUpdateInProgress = false;
    if(mounted){
      setState(() {});
    }

    if(response.isSuccess){
      AuthenticationController.updateUserInformation(
        UserModel(
          email: _emailTEController.text.trim(),
          firstName: _firstNameTEController.text.trim(),
          lastName: _lastNameTEController.text.trim(),
          mobile: _phoneNumberTEController.text.trim(),
          photo: photoBase64 ?? AuthenticationController.user?.photo,
        ),
      );
      if(mounted){
        showSnackMassage(context, 'Profile Update Successfully');
      }
    }
    else{
      if(mounted){
        showSnackMassage(context, 'Profile Update Failed, Please Try again');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileSummaryCard(
              enableOnTap: false,
            ),
            Expanded(
              child: BodyBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Profile',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const SizedBox(
                            height: 16,
                          ),
                          photoPickerField(),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _emailTEController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (String? value){
                              if(value!.trim().isEmpty ?? true){
                                return 'Enter Your Email';
                              }
                              else return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _firstNameTEController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                            ),
                            validator: (String? value){
                              if(value!.trim().isEmpty ?? true){
                                return 'Enter Your First Name';
                              }
                              else{
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _lastNameTEController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                            ),
                            validator: (String? value){
                              if(value!.trim().isEmpty ?? true){
                                return 'Enter Your Last name';
                              }
                              else{
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _phoneNumberTEController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                            ),
                            validator: (String? value){
                              if(value!.trim().isEmpty ?? true){
                                return 'Enter Yoyr Phone Number';
                              }
                              else{
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _passwordTEController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: 'Password (Optional)',
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: _profileUpdateInProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: (){
                                  if(_formKey.currentState!.validate()){
                                     updateProfile();
                                  }
                                },
                                child: const Icon(Icons.arrow_circle_right_outlined),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container photoPickerField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async{
                final XFile? image = await ImagePicker()
                    .pickImage(source: ImageSource.camera, imageQuality: 50);
                if (image != null) {
                  photo = image;
                  if (mounted) {
                    setState(() {});
                  }
                }
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Visibility(
                    visible: photo == null,
                    replacement: Text(photo?.name ?? ''),
                    child: Text('Select A Photo'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _phoneNumberTEController.dispose();
    _passwordTEController.dispose();
  }
}
