import 'package:driver/services/auth.dart';
import 'package:driver/services/database.dart';
import 'package:driver/shared/constants.dart';
import 'package:driver/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({ required this.toggleView });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  
  String email = '';
  String password = '';
  String name = '';
  String company = '';
  String document = '';
  
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('xBus'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person, color: Colors.white),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            label: const Text('Entrar'),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'E-mail'),
                validator: (value) => (
                  value!.isEmpty ? 'Digite um e-mail' : null
                ),
                onChanged: (value) {
                  setState(() => email = value);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Nome'),
                validator: (value) => (
                  value!.isEmpty ? 'Digite seu nome' : null
                ),
                onChanged: (value) {
                  setState(() => name = value);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Empresa'),
                validator: (value) => (
                  value!.isEmpty ? 'Digite sua empresa' : null
                ),
                onChanged: (value) {
                  setState(() => company = value);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Documento'),
                validator: (value) => (
                  value!.isEmpty ? 'Digite um documento' : null
                ),
                onChanged: (value) {
                  setState(() => document = value);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Senha'),
                obscureText: true,
                validator: (value) => (
                  value!.length < 6 ? 'Sua senha deve ter pelo menos 6 caracteres' : null
                ),
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'Digite um e-mail válido';
                        loading = false;
                      });
                    } else {
                      DatabaseService().updateDriver(
                        result.uid, 
                        email,
                        company,
                        document,
                        name,
                        'photo',
                      );
                    }
                  }
                }, 
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(color: Colors.white),
                )
              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}