import 'package:dio/dio.dart';
import 'package:nike/core/params/submit_order_params.dart';
import 'package:nike/core/utils/validator.dart';
import 'package:nike/features/payment_feature/data/model/order_model.dart';
import 'package:nike/features/payment_feature/data/model/receipt_model.dart';
import 'package:nike/features/payment_feature/data/model/order_record_model.dart';

abstract class IOrderDatasource {
  Future<OrderModel> submitOrder(SubmitOrderParams params);
  Future<ReceiptModel> getReceipt(int orderId);
  Future<List<OrderRecordModel>> getOrderRecords();
}

class OrderRemoteDatasource implements IOrderDatasource {
  final Dio dio;

  OrderRemoteDatasource(this.dio);

  // submit order
  @override
  Future<OrderModel> submitOrder(SubmitOrderParams params) async {
    final response = await dio.post('order/submit', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'postal_code': params.postalCode,
      'mobile': params.phoneNumber,
      'address': params.address,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery',
    });

    validateResponse(response);

    return OrderModel.fromJson(response.data);
  }

  // get order receipt
  @override
  Future<ReceiptModel> getReceipt(int orderId) async {
    final response = await dio.get('order/checkout?order_id=$orderId');

    validateResponse(response);

    return ReceiptModel.fromJson(response.data);
  }

  // get all order records
  @override
  Future<List<OrderRecordModel>> getOrderRecords() async {
    final response = await dio.get('order/list');

    validateResponse(response);

    return (response.data as List)
        .map((e) => OrderRecordModel.fromJson(e))
        .toList();
  }
}
