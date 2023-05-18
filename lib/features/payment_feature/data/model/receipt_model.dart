class ReceiptModel {
  bool purchaseSuccess;
  int payablePrice;
  String paymentStatus;

  ReceiptModel.fromJson(Map<String, dynamic> json)
      : purchaseSuccess = json['purchase_success'],
        payablePrice = json['payable_price'],
        paymentStatus = json['payment_status'];
}
