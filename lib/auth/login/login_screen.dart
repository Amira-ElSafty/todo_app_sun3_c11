import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_c11/app_colors.dart';
import 'package:flutter_app_todo_sun_c11/auth/custom_text_form_field.dart';
import 'package:flutter_app_todo_sun_c11/auth/register/register_screen.dart';
import 'package:flutter_app_todo_sun_c11/dialog_utils.dart';
import 'package:flutter_app_todo_sun_c11/home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login_screen';
  TextEditingController emailController =
      TextEditingController(text: 'amira@route.com');
  TextEditingController passwordController =
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
            title: Text('Login'),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          login(context);
                        },
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text('OR Create Account'))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void login(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      //todo: showLoading
      DialogUtils.showLoading(context: context, message: 'Waiting....');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        //todo: hideLoading
        DialogUtils.hideLoading(context);
        //todo: showMessage
        DialogUtils.showMessage(
            context: context,
            content: 'Login Successfully',
            title: 'Success',
            posActionName: 'Ok',
            posAction: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            });
        print('login scuccessfully');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          //todo: hideLoading
          DialogUtils.hideLoading(context);
          //todo: showMessage
          DialogUtils.showMessage(
              context: context,
              content:
                  'The supplied auth credential is incorrect, malformed or has expired.',
              title: 'Error',
              posActionName: 'Ok');
          print(
            'The supplied auth credential is incorrect, malformed or has expired.',
          );
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
            posActionName: 'Ok');
        print(e.toString());
      }
    }
  }
}
