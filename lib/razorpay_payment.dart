import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import './razorpay_key.dart';
import 'package:shop_app/screens/cart_screen.dart';

class RazorPayPage extends StatefulWidget {
  static const routeName = '/razor';
  final double amount;
  final VoidCallback onSuccess;

  RazorPayPage({required this.amount, required this.onSuccess});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorpay;

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void openCheckout() async {
    var options = {
      'key': razorpayKey,
      'amount': (widget.amount * 100).toInt(),
      'name': 'shop',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@gmail.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment Successful: ' + response.paymentId!,
      toastLength: Toast.LENGTH_SHORT,
    );
    widget.onSuccess(); // Clear the cart and add order on success
    Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment Failed: ' + response.message!,
      toastLength: Toast.LENGTH_SHORT,
    );
    Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'External Wallet: ' + response.walletName!,
      toastLength: Toast.LENGTH_SHORT,
    );
    Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Container(width: double.infinity,
              child: Image.network(
                'https://cdn.vectorstock.com/i/1000x1000/80/89/black-and-white-shop-hand-written-word-text-vector-25438089.webp',
                width: 330,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Total Amount: \$${widget.amount.toStringAsFixed(2)}',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: openCheckout,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Proceed to Payment'),
              ),
              style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
