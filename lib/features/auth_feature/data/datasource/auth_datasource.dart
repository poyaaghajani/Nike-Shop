import 'package:dio/dio.dart';
import 'package:nike/core/params/auth_params.dart';
import 'package:nike/core/params/refresh_params.dart';
import 'package:nike/core/utils/validator.dart';
import 'package:nike/features/auth_feature/data/model/auth.dart';

abstract class IAuthDatasource {
  Future<AuthModel> logIn(AuthParams params);
  Future<AuthModel> singUp(AuthParams params);
  Future<AuthModel> refreshToken(RefreshParams params);
}

class AuthRemoteDatasource implements IAuthDatasource {
  final Dio dio;
  AuthRemoteDatasource(this.dio);

  // login
  @override
  Future<AuthModel> logIn(AuthParams params) async {
    final response = await dio.post('auth/token', data: {
      'grant_type': params.grantType,
      'client_id': params.clientId,
      'client_secret': params.clientSecret,
      'username': params.username,
      'password': params.password,
    });

    validateResponse(response);

    return AuthModel(
      response.data['access_token'],
      response.data['refresh_token'],
      params.username,
    );
  }

  // singup
  @override
  Future<AuthModel> singUp(AuthParams params) async {
    final response = await dio.post('user/register', data: {
      'email': params.username,
      'password': params.password,
    });

    validateResponse(response);

    return logIn(params);
  }

  // refresh token
  @override
  Future<AuthModel> refreshToken(RefreshParams params) async {
    final response = await dio.post('auth/token', data: {
      'grant_type': params.grantType,
      'refresh_token': params.token,
      'client_secret': params.clientSecret,
      'client_id': params.clientId,
    });

    validateResponse(response);

    return AuthModel(
      response.data['access_token'],
      response.data['refresh_token'],
      '',
    );
  }
}
