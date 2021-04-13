import 'package:flutter/material.dart';
import 'package:plants_app/models/AuthModel.dart';
import 'package:provider/provider.dart';

import 'package:reactive_forms/reactive_forms.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FormGroup buildForm() => fb.group(<String, dynamic>{
        'username': ['', Validators.required],
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
        'password': ['', Validators.required, Validators.minLength(8)],
        'passwordConfirmation': [
          '',
          Validators.required,
          Validators.minLength(8)
        ],
      }, [
        Validators.mustMatch('password', 'passwordConfirmation')
      ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Title(color: Colors.green, child: const Text('Create account')),
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
                        formControlName: 'username',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The username must not be empty',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          labelText: 'Username',
                          helperText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'email',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The email must not be empty',
                          ValidationMessage.email:
                              'The email value must be a valid email',
                          'unique': 'This email is already in use',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.email),
                          labelText: 'Email',
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
                          ValidationMessage.minLength:
                              'The password must be at least 8 characters',
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
                      ReactiveTextField<String>(
                        formControlName: 'passwordConfirmation',
                        obscureText: true,
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The password must not be empty',
                          ValidationMessage.minLength:
                              'The password must be at least 8 characters',
                          ValidationMessage.mustMatch: 'Passwords don\'t match'
                        },
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.lock),
                          labelText: 'Password confirmation',
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
                              'username': ControlState<String>(value: null),
                              'email': ControlState<String>(value: null),
                              'password': ControlState<String>(value: null),
                              'passwordConfirmation':
                                  ControlState<bool>(value: false),
                            }, removeFocus: true);
                          } else {
                            form.markAllAsTouched();
                          }
                        },
                        child: const Text('Sign Up'),
                      )
                    ],
                  ));
            },
          );
        }));
  }
}
