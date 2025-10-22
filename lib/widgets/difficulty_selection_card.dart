import 'package:dodecathlon/utilities/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DifficultySelectionCard extends StatelessWidget {

  const DifficultySelectionCard({
    super.key,
    required this.themeColor,
    required this.title,
    required this.subtitle,
    required this.description
  });

  final Color themeColor;
  final String title;
  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: ColorUtility().lighten(themeColor, .3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            ),
            child: Column(
              children: [
                Text(title, style: GoogleFonts.robotoMono(fontSize: 35),),
                Text(subtitle, style: GoogleFonts.robotoMono(fontSize: 20),),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Text(description),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: FilledButton(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(ColorUtility().lighten(themeColor))),
                onPressed: () {},
                child: Text('Select')
            ),
          )
        ],
      ),
    );
  }
}