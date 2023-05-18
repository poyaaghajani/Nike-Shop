import 'package:dio/dio.dart';
import 'package:nike/core/utils/exeption.dart';

validateResponse(Response response) {
  if (response.statusCode != 200) {
    throw AppExeption();
  }
}
