import 'package:flutter/material.dart';
import 'package:git/services/stripe_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                await StripeService.instance.makePayment();
              },
              color: Colors.red,
              child: Text("ادفع"),
            )
          ],
        ),
      ),
    );
  }
}
