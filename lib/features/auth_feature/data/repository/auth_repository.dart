import 'package:flutter/material.dart';
import 'package:nike/core/params/auth_params.dart';
import 'package:nike/core/params/refresh_params.dart';
import 'package:nike/core/utils/api_service.dart';
import 'package:nike/features/auth_feature/data/datasource/auth_datasource.dart';
import 'package:nike/features/auth_feature/data/model/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// inject repository for all project
final authRepository = AuthRepository(AuthRemoteDatasource(dio));

abstract class IAuthRepository {
  Future<void> logIn(AuthParams params);
  Future<void> singUp(AuthParams params);
  Future<void> refreshToken(RefreshParams params);
  Future<void> logOut();
}

class AuthRepository implements IAuthRepository {
  final IAuthDatasource authDatasource;
  static final ValueNotifier<AuthModel?> authChangeNotifire =
      ValueNotifier(null);

  AuthRepository(this.authDatasource);

  // login
  @override
  Future<void> logIn(AuthParams params) async {
    final AuthModel authModel = await authDatasource.logIn(params);

    saveAuthToken(authModel);
  }

  // singup
  @override
  Future<void> singUp(AuthParams params) async {
    final AuthModel authModel = await authDatasource.singUp(params);

    saveAuthToken(authModel);
  }

  // refresh token
  @override
  Future<void> refreshToken(RefreshParams params) async {
    final AuthModel authModel = await authDatasource.refreshToken(params);

    saveAuthToken(authModel);
  }

  // create a method to save tokens
  Future<void> saveAuthToken(AuthModel authModel) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString('access_token', authModel.accessToken);
    pref.setString('refresh_token', authModel.refreshToken);
    pref.setString('email', authModel.email);

    readAuthToken();
  }

  // create a method to read tokens
  Future<void> readAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String accessToken = pref.getString('access_token') ?? '';
    final String refreshToken = pref.getString('refresh_token') ?? '';
    final String email = pref.getString('email') ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifire.value = AuthModel(accessToken, refreshToken, email);
    }
  }

  // logOut
  @override
  Future<void> logOut() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.clear();
    authChangeNotifire.value = null;
  }
}
