library flutter_html_text_view;

import 'package:flutter/material.dart';
import 'package:flutter_htmltextview/html_container.dart';
import 'package:flutter_htmltextview/html_parser.dart';

class HtmlTextView extends StatelessWidget {
  final String data;
  final String customFont;
  final String customFontBold;
  final Color anchorColor;

  HtmlTextView(
      {this.data, this.customFont, this.customFontBold, this.anchorColor});

  @override
  Widget build(BuildContext context) {
    HtmlParser parser = HtmlParser(
        data: this.data,
        customFontBold: this.customFontBold,
        customFont: this.customFont,
        anchorColor: this.anchorColor);
    HtmlContainer child = parser.parse();

    return new Container(
        padding: const EdgeInsets.all(0.0), child: child.render());
  }
}
