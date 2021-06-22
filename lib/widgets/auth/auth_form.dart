import 'dart:io';

import 'package:flutter/material.dart';

import '../../widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitHandler;
  final bool loading;
  AuthForm(this.submitHandler, this.loading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userPassword = '';
  var _password2 = '';

  final TextEditingController _passwordController = TextEditingController();

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitHandler(
        _userEmail.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Adress',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return "Password length must be atleast 7 characters!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('password2'),
                      validator: (value) {
                        print(_passwordController.text);
                        if (value.isEmpty ||
                            value != _passwordController.text) {
                          return "Passwords do not match!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                      onSaved: (value) {
                        _password2 = value;
                      },
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.loading) CircularProgressIndicator(),
                  if (!widget.loading)
                    ElevatedButton(
                      child: Text(_isLogin ? "Login" : "Signup"),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.loading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
