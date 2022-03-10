import 'package:firebase_chat_app_using_getx/ui/SignUpScreen/sign_up_controller.dart';
import 'package:firebase_chat_app_using_getx/utils/app_utils.dart';
import 'package:firebase_chat_app_using_getx/utils/center_button.dart';
import 'package:firebase_chat_app_using_getx/utils/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(builder: (controller) {
      return Scaffold(
        body: bodyView(),
      );
    });
  }

  Widget bodyView() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Form(
        key: signUpController.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonTextfield(
                controller: signUpController.userNameController,
                hintText: "User Name"),
            const SizedBox(
              height: 15,
            ),
            CommonTextfield(
                controller: signUpController.emailController,
                hintText: "Email",
                emptyValidation: false,
                validation: (value) {
                  if (value == "" || !GetUtils.isEmail(value)) {
                    return "Email is not valid";
                  } else {
                    return null;
                  }
                }),
            const SizedBox(
              height: 15,
            ),
            CommonTextfield(
              controller: signUpController.passwordController,
              hintText: "Password",
              isSecure: signUpController.isSecure,
              maxLine: 1,
              suffixWidget: InkWell(
                onTap: () {
                  signUpController.setSecureUnSecure();
                },
                child: Icon(signUpController.isSecure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CenterButton(
                ontap: () {
                  signUpController.signUpWithEmailAndPassword();
                },
                text: "Sign Up"),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: blackRegular16,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(" SignIn now",
                      style: blackRegular16.copyWith(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
