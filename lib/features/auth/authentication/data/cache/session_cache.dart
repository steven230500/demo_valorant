import 'package:get_it/get_it.dart';

enum RoleUser {
  admin,
  viewer
}
class SessionCache {
  String? name;
  RoleUser? role;
  RoleUser? roleSelected;

  void clear() {
    name = null;
    role = null;
    roleSelected = null;
  }
}

final cacheUser = GetIt.I<SessionCache>();