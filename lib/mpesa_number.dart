import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/colors.dart';

class MpesaNumber extends StatefulWidget {
  const MpesaNumber(
      {Key? key,
      required this.number,
      required this.index,
      required this.selectedIndex,
      required this.onIndexChanged})
      : super(key: key);

  final String number;
  final int selectedIndex;
  final int index;
  final VoidCallback onIndexChanged;

  @override
  _MpesaNumberState createState() => _MpesaNumberState();
}

class _MpesaNumberState extends State<MpesaNumber> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color(0xfff5f2fe),
          borderRadius: BorderRadius.circular(6)),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.index == widget.selectedIndex
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle_rounded,
                          color: AppColors.indexcolor),
                    )
                  : IconButton(
                      onPressed: () {
                        widget.onIndexChanged();
                      },
                      icon: const Icon(
                        Icons.radio_button_unchecked,
                      )),
              const SizedBox(
                width: 10,
              ),
              Text("${widget.number}",
                  style: GoogleFonts.lato(
                    color: const Color(0xff111111),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ))
            ],
          ),
          //evans. we dont know the fee. so lets not display it
          /*   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.index == widget.selectedIndex
                  ? Text("Fee: KES 0.00",
                      style: GoogleFonts.lato(
                        color: Color(0xff111111),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ))
                  : Opacity(opacity: 0)
            ],
          ) */
        ],
      ),
    );
  }
}
