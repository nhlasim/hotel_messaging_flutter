enum UserRoles { admin, super_user, manager, staff }

extension UserRolesString on String {
  UserRoles get userRoles {
    switch (this) {
      case 'admin':
        return UserRoles.admin;
      case 'super_user':
        return UserRoles.super_user;
      case 'manager':
        return UserRoles.manager;
      case 'staff':
        return UserRoles.staff;
      default:
        throw Exception();
    }
  }
}

extension UserRolesEnum on UserRoles {
  String get enumToString {
    switch (this) {
      case UserRoles.admin:
        return 'Admin';
      case UserRoles.super_user:
        return 'Super User';
      case UserRoles.manager:
        return 'Manager';
      case UserRoles.staff:
        return 'Staff';
      default:
        throw Exception();
    }
  }
}