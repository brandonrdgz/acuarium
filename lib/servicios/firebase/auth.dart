import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static Future<UserCredential> registrar({required String correo, required String contrasenia}) async {
    return FirebaseAuth
      .instance
      .createUserWithEmailAndPassword(
        email: correo,
        password: contrasenia
      );
  }
}