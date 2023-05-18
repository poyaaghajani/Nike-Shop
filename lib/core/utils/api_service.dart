import 'package:dio/dio.dart';
import 'package:nike/features/auth_feature/data/repository/auth_repository.dart';

// set base URL and header for all requests
final dio = Dio(
  BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'),
)..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = AuthRepository.authChangeNotifire.value;
      if (token != null && token.accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      }

      handler.next(options);
    },
  ));
