import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get userStream => _auth.authStateChanges();

  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    }
  }

  // 3. Inicio de Sesión
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    }
  }

  // 4. Cerrar Sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error al cerrar sesión: $e");
    }
  }

  // Manejador de errores centralizado
  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        debugPrint('La contraseña es muy débil.');
        break;
      case 'email-already-in-use':
        debugPrint('Ya existe una cuenta con este correo.');
        break;
      case 'user-not-found':
        debugPrint('No existe un usuario con este correo.');
        break;
      case 'wrong-password':
        debugPrint('Contraseña incorrecta.');
        break;
      case 'invalid-email':
        debugPrint('El formato del correo es inválido.');
        break;
      default:
        debugPrint('Error de Firebase: ${e.message}');
    }
  }
}