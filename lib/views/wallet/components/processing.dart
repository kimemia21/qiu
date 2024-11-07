import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/colors.dart';
import '../../../utils/widgets.dart';

class ProcessingDialog extends StatelessWidget {
  ProcessingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: processingcontentBox(context) //: showtoken(context),
        );
  }

  Widget showtoken(context) {
    return Center(
      child: Container(
        height: 500,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Success',
                style: TextStyle(fontSize: 30.0, color: AppColors.appblue),
              ),
              labelField("Meter", "!.meter_number}"),
              // meter!.metertype.toString().contains("elec")
              //     ? Image.asset("assets/images/electoken.jpg")
              //     : Image.asset("assets/images/watertoken.jpeg"),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: " .token! "));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Copied to Clipboard"),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copy),
                    Text(
                      'Copy Token #',
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown, // This scales the Text to fit
                  child: Text(
                    '{token!.token}',
                    style: const TextStyle(
                        fontSize: 40.0,
                        letterSpacing: 5.0,
                        color: Colors.black87), // Initial font size
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 5,
              ),
              myButtons(
                  context, "Close", Icons.close, () => Navigator.pop(context)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget processingcontentBox(context) {
    return Center(
      child: Container(
        height: 420,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Custom transferring money animation

              const SizedBox(height: 20.0),
              const Text(
                'Processing ...',
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
              // if (meter != null)
              //   if ((meter!.can_auto_load_tokens) ?? false)
              const Text(
                'Your Meter supports automatic Token loading',
                style: TextStyle(fontSize: 12.0, color: Colors.black87),
              ),
              const SizedBox(height: 20.0),
              Image.asset("assets/images/transfer.png"),
              const SizedBox(height: 20.0),
              TransferMoneyAnimation(),
              // myButtons(
              //     context, "Close", Icons.close, () => Navigator.pop(context))
            ],
          ),
        ),
      ),
    );
  }
}

class TransferMoneyAnimation extends StatefulWidget {
  @override
  _TransferMoneyAnimationState createState() => _TransferMoneyAnimationState();
}

class _TransferMoneyAnimationState extends State<TransferMoneyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start from the left
      end: const Offset(1.0, 0.0), // Move to the right
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    transferfunds();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const Icon(
        Icons.wallet,
        size: 60.0,
        color: Colors.green,
      ),
    );
  }

  void transferfunds() async {}
}

void showProcessingDialog(BuildContext context, meter, token) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ProcessingDialog(
          // meter: meter,
          // token: token,
          );
    },
  );
}

void closeProcessingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
