import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:git/consts.dart';

class StripeService {
  StripeService._();
  // static final StripeService insatnce = StripeService._();
  static final StripeService instance = StripeService._(); // fix spelling

  Future<void> makePayment() async {
    try {
      String clientSecret = await _createPaymentIntent(100, 'usd');
      print("Client Secret: $clientSecret");
      if (clientSecret == null) {
        throw Exception("Client secret is null");
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: "Tarek Kallasi"),
      );
      await Stripe.instance.presentPaymentSheet();
      print("Done");
      return;
      // await _proccessPayment;
    } catch (e) {
      print("Payment Error: $e");
    }
  }

  Future<String> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAamount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $strisecertkey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null && response.data['client_secret'] != null) {
        return response.data['client_secret'];
      } else {
        throw Exception("Client secret not found in response");
      }
    } catch (e) {
      throw Exception("Failed to create payment intent: $e");
    }
  }

  Future<void> _proccessPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print(e);
    }
  }

  String _calculateAamount(int amount) {
    final calucaltedAmount = amount * 100;
    return calucaltedAmount.toString();
  }
}
