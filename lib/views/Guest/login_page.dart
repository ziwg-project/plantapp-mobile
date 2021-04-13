import 'package:flutter/material.dart';
import 'package:plants_app/models/AuthModel.dart';
import 'package:plants_app/views/Guest/remind_password_page.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FormGroup buildForm() => fb.group(<String, dynamic>{
        'login': ['', Validators.required],
        'password': ['', Validators.required],
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Title(color: Colors.green, child: const Text('Sign in')),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RemindPasswordPage()));
              },
              child: const Text('Reset password')),
        ),
        body: Consumer<AuthModel>(builder: (context, auth, child) {
          return ReactiveFormBuilder(
            form: buildForm,
            builder: (context, form, child) {
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReactiveTextField<String>(
                        formControlName: 'login',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The login must not be empty',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          labelText: 'Login / email',
                          helperText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ReactiveTextField<String>(
                        formControlName: 'password',
                        obscureText: true,
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The password must not be empty',
                        },
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                          helperText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15))),
                        onPressed: () {
                          if (form.valid) {
                            form.resetState({
                              'email': ControlState<String>(value: null),
                              'password': ControlState<String>(value: null),
                            }, removeFocus: true);
                            auth.logIn();
                          } else {
                            form.markAllAsTouched();
                          }
                        },
                        child: const Text('Sign in'),
                      ),
                    ],
                  ));
            },
          );
        }));
  }
}
