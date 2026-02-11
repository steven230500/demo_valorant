import 'package:commons/commons.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'features/auth/authentication/data/cache/session_cache.dart';

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

      if(credential.user != null) {
        final token = await credential.user?.getIdToken();
        debugPrint(token);
        final client = Dio(
          BaseOptions(
            baseUrl: Constants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            },
          ),
        );
        if(cacheUser.roleSelected != null) {
          try{
            final isAdmin = cacheUser.roleSelected == RoleUser.admin;
            final resultUserData = await client.post(
              '/user',
              data: {"isAdmin": isAdmin },
            );

            if(resultUserData.statusCode == 200){
              cacheUser.name = resultUserData.data["user"]["name"];
              cacheUser.role = resultUserData.data["user"]["role"] == "admin"
                  ? RoleUser.admin
                  : RoleUser.viewer;
            }
            else {
              signOut();
              throw resultUserData;
            }
          }
          catch(e){
            signOut();
            rethrow;
          }

        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    }
  }

  // 4. Cerrar Sesión
  Future<void> signOut() async {
    try {
      cacheUser.clear();
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