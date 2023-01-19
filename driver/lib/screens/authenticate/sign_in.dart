import 'package:driver/shared/constants.dart';
import 'package:driver/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({ required this.toggleView });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  
  String email = '';
  String password = '';
  
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        elevation: 0.0,
        title: Text('xbus'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.green),
            style: TextButton.styleFrom(primary: Colors.green),
            label: Text('Cadastro'),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'E-mail'),
                  validator: (value) => (
                    value!.isEmpty ? 'Digite um e-mail' : null
                  ),
                  onChanged: (value) {
                    setState(() => email = value);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (value) => (
                    value!.length < 6 ? 'Sua senha deve ter pelo menos 6 caracteres' : null
                  ),
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => loading = true);
                      // TODO: add firebase
                      dynamic result = await null;
                      if (result == null) {
                        setState(() {
                          error = 'Credenciais inválidas';
                          loading = false;
                        });
                      }
                    }
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  child: Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white),
                  )
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
            ],
          ),
        ),
      ),
    );
  }
}