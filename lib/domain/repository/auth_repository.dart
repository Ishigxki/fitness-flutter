
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User?> signIn({required String email, required String password});
  Future<void> signOut();
  Future<bool> isUserSignedIn();
}

// TODO: Implement the AuthRepository