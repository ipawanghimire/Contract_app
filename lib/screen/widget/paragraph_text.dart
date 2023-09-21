import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_constant.dart';

class TextFormatter {
  static Widget formatTextWithBold(String text) {
    final parts = text.split('{bold}');
    final List<InlineSpan> children = [];
    for (var i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        // Regular text
        children.add(TextSpan(
          text: parts[i],
          style: GoogleFonts.mali(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 29, 27, 27),
          ),
        ));
      } else {
        // Bold text
        children.add(TextSpan(
          text: parts[i],
          style: GoogleFonts.mali(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 29, 27, 27),
          ),
        ));
      }
    }
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(children: children),
    );
  }
}

class TextParagraph extends StatelessWidget {
  const TextParagraph({super.key});

  @override
  Widget build(BuildContext context) {
    final formattedText = TextFormatter.formatTextWithBold(
      AppConstants.agreementText,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: formattedText,
    );
  }
}
