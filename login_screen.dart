import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Password too short' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(isLogin ? 'Login' : 'Sign Up'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isLogin) {
                      authViewModel.login(_emailController.text, _passwordController.text);
                    } else {
                      authViewModel.signUp(_emailController.text, _passwordController.text);
                    }
                  }
                },
              ),
              TextButton(
                child: Text(isLogin ? "Don't have an account? Sign up" : "Already have an account? Login"),
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
