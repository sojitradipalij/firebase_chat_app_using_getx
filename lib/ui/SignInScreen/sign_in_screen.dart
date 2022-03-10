import 'package:firebase_chat_app_using_getx/ui/SignInScreen/sign_in_controller.dart';
import 'package:firebase_chat_app_using_getx/ui/SignUpScreen/sign_up_screen.dart';
import 'package:firebase_chat_app_using_getx/utils/app_utils.dart';
import 'package:firebase_chat_app_using_getx/utils/center_button.dart';
import 'package:firebase_chat_app_using_getx/utils/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(builder: (controller) {
      return Scaffold(
        body: bodyView(),
      );
    });
  }

  Widget bodyView() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Form(
        key: signInController.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonTextfield(
                controller: signInController.emailController,
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
              controller: signInController.passwordController,
              hintText: "Password",
              isSecure: signInController.isSecure,
              maxLine: 1,
              suffixWidget: InkWell(
                onTap: () {
                  signInController.setSecureUnSecure();
                },
                child: Icon(signInController.isSecure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CenterButton(
                ontap: () {
                  signInController.signInWithEmailAndPassword();
                },
                text: "Sign In"),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account?",
                  style: blackRegular16,
                ),
                InkWell(
                  onTap: () {
                    Get.to(SignUpScreen());
                  },
                  child: Text(" Register now",
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
