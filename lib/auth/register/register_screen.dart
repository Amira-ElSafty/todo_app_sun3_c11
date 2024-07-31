import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_c11/app_colors.dart';
import 'package:flutter_app_todo_sun_c11/auth/custom_text_form_field.dart';
import 'package:flutter_app_todo_sun_c11/dialog_utils.dart';
import 'package:flutter_app_todo_sun_c11/home/home_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register_screen';
  TextEditingController nameController = TextEditingController(text: 'Amira');
  TextEditingController emailController =
      TextEditingController(text: 'amira@route.com');
  TextEditingController passwordController =
      TextEditingController(text: '123456');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '123456');
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: AppColors.backgroundLightColor,
            child: Image.asset(
              'assets/images/main_background.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            )),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Create Account'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  CustomTextFormField(
                      label: 'User Name',
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter User Name.';
                        }
                        return null;
                      }),
                  CustomTextFormField(
                      label: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Email.';
                        }
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return 'Please enter valid Email.';
                        }
                        return null;
                      }),
                  CustomTextFormField(
                      label: 'Password',
                      controller: passwordController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Password.';
                        }
                        if (text.length < 6) {
                          return 'Password should be at least 6 chars.';
                        }
                        return null;
                      }),
                  CustomTextFormField(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Confirm Password.';
                        }
                        if (text != passwordController.text) {
                          return "Confirm Password doesn't match Password.";
                        }
                        return null;
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          register(context);
                        },
                        child: Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void register(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      //todo: showLoading
      DialogUtils.showLoading(context: context, message: 'Loading...');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        //todo: hideLoading
        DialogUtils.hideLoading(context);
        //todo: showMessage
        DialogUtils.showMessage(
            context: context,
            content: 'Register Successfully',
            title: 'Success',
            posActionName: 'Ok',
            posAction: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            });
        print('Register Successfully.');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //todo: hideLoading
          DialogUtils.hideLoading(context);
          //todo: showMessage
          DialogUtils.showMessage(
              context: context,
              content: 'The password provided is too weak.',
              title: 'Error',
              posActionName: 'Ok');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          //todo: hideLoading
          DialogUtils.hideLoading(context);
          //todo: showMessage
          DialogUtils.showMessage(
              context: context,
              content: 'The account already exists for that email.',
              title: 'Error',
              posActionName: 'Ok');
          print('The account already exists for that email.');
        } else if (e.code == 'network-request-failed') {
          //todo: hideLoading
          DialogUtils.hideLoading(context);
          //todo: showMessage
          DialogUtils.showMessage(
              context: context,
              content:
                  ' A network error (such as timeout, interrupted connection or unreachable host) has occurred',
              title: 'Error',
              posActionName: 'Ok');
          print('The account already exists for that email.');
        }
      } catch (e) {
        //todo: hideLoading
        DialogUtils.hideLoading(context);
        //todo: showMessage
        DialogUtils.showMessage(
          context: context,
          content: e.toString(),
          title: 'Error',
          posActionName: 'Ok',
        );
        print(e);
      }
    }
  }
}
