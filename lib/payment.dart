import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  final amount;
  Payment({this.amount});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  //static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    openCheckout();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  bool beforePayment = false;
  bool success = false;
  @override
  Widget build(BuildContext context) {
    return beforePayment
        ? SafeArea(
            child: Scaffold(
              body: Container(
                padding:
                    EdgeInsets.only(top: 60, bottom: 10, left: 6, right: 6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        // (redirect==0)?
                        // 'Redirecting to Payment gateway..\nPlease wait' :
                        !success ? 'Payment Failed' : 'Payment success!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            //fontSize: Screen.displayWidth(context) * 0.065,
                            fontWeight: FontWeight.w600),
                      ),
                      if (success)
                        //Todo:Add gif
                        Container(
                          height: 500,
                          width: 400,
                          child: Image(
                            image: AssetImage('images/test.jpg'),
                            //TODO add gif image here
                          ),
                        ),
                      if (!success)
                        Container(
                          height: 500,
                          width: 400,
                          child: Image(
                            image: AssetImage('images/test.jpg'),
                            //TODO add gif image here
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigation.changeScreenReplacement(
                            //     context: context, screen: MyPosts());
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'Go Back',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                            ),
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': num.parse(widget.amount) * 100,
      'name': 'Test App',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
    setState(() {
      beforePayment = true;
      success = true;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
    setState(() {
      beforePayment = true;
      success = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }
}
