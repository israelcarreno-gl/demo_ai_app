import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    DateTime? emailConfirmedAt,
    String? phone,
    DateTime? lastSignInAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      emailConfirmedAt: _parseDateTime(user.emailConfirmedAt),
      phone: user.phone,
      lastSignInAt: _parseDateTime(user.lastSignInAt),
      createdAt: _parseDateTime(user.createdAt),
      updatedAt: _parseDateTime(user.updatedAt),
    );
  }

  static DateTime? _parseDateTime(String? dateTime) {
    if (dateTime == null) return null;
    return DateTime.tryParse(dateTime);
  }
}
