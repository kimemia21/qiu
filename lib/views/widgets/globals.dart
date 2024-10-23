import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController myController;
  final String? hintText;
  final bool? isPassword;
  const CustomTextfield(
      {Key? key, required this.myController, this.hintText, this.isPassword})
      : super(key: key);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool hidepass = false;
  @override
  void initState() {
    super.initState();
    hidepass = widget.isPassword! ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: widget.isPassword!
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        enableSuggestions: widget.isPassword! ? false : true,
        autocorrect: widget.isPassword! ? false : true,
        obscureText: hidepass,
        controller: widget.myController,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword!
              ? IconButton(
                  icon: Icon(Icons.remove_red_eye,
                      color: hidepass ? Colors.grey : Colors.green),
                  onPressed: () {
                    setState(() {
                      hidepass = !hidepass;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
              borderRadius: BorderRadius.circular(10)),
          fillColor: const Color(0xffE8ECF4),
          filled: true,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

Widget buildWideButton(
    BuildContext context, String text, Color color, onpressed,
    {bool showarrow = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
      ),
      onPressed: onpressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(fontSize: 18)),
          if (showarrow) Icon(Icons.arrow_forward),
        ],
      ),
    ),
  );
}

Widget CustomButton(BuildContext context, String text, pressed) {
  return Container(
    width: 220,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Colors.white,
              width: 1.5,
            ),
          ),
        ),
        onPressed: pressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: 18)),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    ),
  );
}
