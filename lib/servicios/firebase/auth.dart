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

  static Future<UserCredential> iniciarSesion({required String correo, required String contrasenia}) async {
    return FirebaseAuth
      .instance
      .signInWithEmailAndPassword(
        email: correo,
        password: contrasenia
      );
  }

  static Future<void> cerrarSesion() {
    return FirebaseAuth.instance.signOut();
  }

  static String? getUserEmail() {
    return FirebaseAuth.instance.currentUser!.email;
  }
  static String? getUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}