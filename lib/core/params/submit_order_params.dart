class SubmitOrderParams {
  String firstName;
  String lastName;
  String phoneNumber;
  String postalCode;
  String address;
  final PaymentMethod paymentMethod;

  SubmitOrderParams({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.postalCode,
    required this.address,
    required this.paymentMethod,
  });
}

enum PaymentMethod { online, cashOnDelivery }
