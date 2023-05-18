import 'package:nike/core/params/submit_order_params.dart';
import 'package:nike/core/utils/api_service.dart';
import 'package:nike/features/payment_feature/data/datasource/order_datasource.dart';
import 'package:nike/features/payment_feature/data/model/order_model.dart';
import 'package:nike/features/payment_feature/data/model/receipt_model.dart';
import 'package:nike/features/payment_feature/data/model/order_record_model.dart';

final orderRepository = OrderRepository(OrderRemoteDatasource(dio));

abstract class IOrderRepository {
  Future<OrderModel> submitOrder(SubmitOrderParams params);
  Future<ReceiptModel> getReceipt(int orderId);
  Future<List<OrderRecordModel>> getOrderRecords();
}

class OrderRepository implements IOrderRepository {
  final IOrderDatasource orderDatasource;

  OrderRepository(this.orderDatasource);

  // submit order
  @override
  Future<OrderModel> submitOrder(SubmitOrderParams params) {
    return orderDatasource.submitOrder(params);
  }

  // get order recepit
  @override
  Future<ReceiptModel> getReceipt(int orderId) {
    return orderDatasource.getReceipt(orderId);
  }

  // get all order records
  @override
  Future<List<OrderRecordModel>> getOrderRecords() {
    return orderDatasource.getOrderRecords();
  }
}
