  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:recipe/provider/auth_provider.dart';

  class LoginScreen extends ConsumerStatefulWidget {
    const LoginScreen({super.key});
    @override
    ConsumerState<LoginScreen> createState() {
      return _LoginScreenState();
    }
  }

  class _LoginScreenState extends ConsumerState<LoginScreen> {
    final _formKey = GlobalKey<FormState>();
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
  @override
    void dispose() {
      _usernameController.dispose();
      _passwordController.dispose();
      super.dispose();
    }
    void _login(){
  if(  _formKey.currentState!.validate()){
  ref.read(authNotifierProvider.notifier).loginAndSave(_usernameController.text.trim(),_passwordController.text.trim());
  }}
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: "Username"),
                      validator: (value) {
                        if(value==null||value.trim().isEmpty){
                          return "Invalid username";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      validator: (value){
                        if(value==null||value.trim().isEmpty){
                          return "Invalid password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 17,),
                    ElevatedButton(onPressed: _login, child: Text('Login')),
                    SizedBox(height:8),
                    TextButton(onPressed: (){}, child: Text("I dont have account"))
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
