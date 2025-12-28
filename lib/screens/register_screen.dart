import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 20),

            if (vm.loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
  onPressed: () async {
    final result = await vm.register(
      name.text,
      email.text,
      password.text,
    );

    if (result == "success") {
      Navigator.pop(context);
    }
  },
  child: const Text("Create Account"),
),


            if (vm.errorMessage != null)
              Text(vm.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
