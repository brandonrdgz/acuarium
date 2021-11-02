import 'package:firebase_auth/firebase_auth.dart';

class Constantes {
  static final RegExp EXP_REG_CONTRASENIA = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[.\-*#$&])[A-Za-z0-9.\-*#$&]{6,}$");
  static final msjsErrorFirebaseAuth = {
    'email-already-in-use': 'El correo ya está registrado',
    'user-not-found': 'Correo/contraseña no válidos',
    'wrong-password': 'Correo/contraseña no válidos',
    'too-many-requests': 'Demasiados intentos. Vuelva a intentarlo más tarde'
  };

  static String mensjeError(dynamic error) {
    String? msjError;

    if (error.runtimeType == FirebaseAuthException) {
      FirebaseAuthException errorFirebaseAuth = error;
      msjError = msjsErrorFirebaseAuth[errorFirebaseAuth.code];
    }

    return msjError ?? error.toString();
  }
}