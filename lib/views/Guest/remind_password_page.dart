import 'package:flutter/material.dart';
import 'package:plants_app/models/AuthModel.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RemindPasswordPage extends StatefulWidget {
  @override
  _RemindPasswordPageState createState() => _RemindPasswordPageState();
}

class _RemindPasswordPageState extends State<RemindPasswordPage> {
  FormGroup buildForm() => fb.group(<String, dynamic>{
        'email': ['', Validators.required, Validators.email],
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Title(color: Colors.green, child: const Text('Reset password')),
        ),
        body: Consumer<AuthModel>(builder: (context, auth, child) {
          return ReactiveFormBuilder(
            form: buildForm,
            builder: (context, form, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReactiveTextField<String>(
                          formControlName: 'email',
                          validationMessages: (control) => {
                            ValidationMessage.required:
                                'The email must not be empty',
                            ValidationMessage.email: 'Invalid email'
                          },
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.person),
                            labelText: 'Email',
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
                              }, removeFocus: true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text('Reset link sent')));
                              Navigator.pop(context);
                            } else {
                              form.markAllAsTouched();
                            }
                          },
                          child: const Text('Reset password'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }));
  }
}
