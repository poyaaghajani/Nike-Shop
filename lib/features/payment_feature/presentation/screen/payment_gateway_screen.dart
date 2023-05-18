import 'package:flutter/material.dart';
import 'package:nike/features/payment_feature/presentation/screen/receipt_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayScreen extends StatelessWidget {
  const PaymentGatewayScreen({
    super.key,
    required this.bankGateway,
  });

  final String bankGateway;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: bankGateway,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) async {
        final uri = Uri.parse(url);

        if (uri.path.contains('appCheckout') &&
            uri.host == 'expertdevelopers.ir') {
          final orderId = int.parse(uri.queryParameters['order_id']!);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return RecepitScreen(orderId: orderId);
              },
            ),
          );
        }
      },
    );
  }
}
