import 'package:fit_quest/viewmodel/auth_view_model.dart';
import 'package:fit_quest/viewmodel/profile_view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth_wrapper.dart'; 

class FitQuestApp extends StatelessWidget {
  const FitQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    final profileVM = context.read<ProfileViewModel>();

    
    profileVM.bindAuthStream(authVM.authStateChanges());

    return const MaterialApp(
      home: AuthWrapper(),
    );
  }
}
