import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../firebase_login_functions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../models/user_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthService authService;

  AuthenticationRepositoryImpl(this.authService);

  @override
  Stream<UserEntity?> get user {
    return authService.userStream.map((user) {
      if (user != null) {
        return UserModel.fromFirebaseUser(user);
      }
      return null;
    });
  }

  @override
  Future<Result<UserEntity>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await authService.signInWithEmail(email, password);
      if (credential?.user != null) {

        return Success<UserEntity>(
          UserModel.fromFirebaseUser(credential!.user!),
        );
      } else {
        return Failure<UserEntity>(const UnknownError('Authentication failed'));
      }
    } on FirebaseAuthException catch (e) {
      return Failure<UserEntity>(
        UnknownError(e.message ?? 'Authentication failed'),
      );
    } catch (e) {
      return Failure<UserEntity>(UnknownError(e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await authService.signOut();
      return const Success<void>(null);
    } catch (e) {
      return Failure<void>(UnknownError(e.toString()));
    }
  }
}
