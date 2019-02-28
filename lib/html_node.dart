import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_htmltextview/html_container.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlNode {
  static const int BOLD = 1;
  static const int ITALIC = 2;
  static const int ANCHOR = 3;

  final String tag;
  final String fontFamily;
  final String fontFamilyBold;
  final String text;
  final String href;

  final double fontSize;
  final Map<dynamic, dynamic> textAttributes;
  final Color color;
  final Color hrefColor;

  final HtmlContainer parent;

  HtmlNode(
      {this.text,
      this.tag,
      this.href,
      this.parent,
      this.fontFamily, //Utilities.interstateLight,
      this.fontSize = 16.0,
      this.fontFamilyBold, // = Utilities.interstateBold,
      this.textAttributes,
      this.hrefColor,
      this.color = const Color(0xFF000000)});

  TextStyle _getStyle() {
    var family = textAttributes.containsKey("bold")
        ? fontFamilyBold != null
            ? fontFamilyBold
            : fontFamily == null ? null : fontFamily
        : fontFamily;

    return TextStyle(
        fontStyle: textAttributes.containsKey("italic")
            ? FontStyle.italic
            : FontStyle.normal,
        fontWeight: textAttributes.containsKey("bold") && fontFamilyBold == null
            ? FontWeight.bold
            : FontWeight.normal,
        fontSize: fontSize,
        decoration: href == null || href == ""
            ? TextDecoration.none
            : TextDecoration.underline,
        fontFamily: family,
        //textAttributes.containsKey("bold") ? fontFamilyBold : fontFamily,
        color:
            href == null || href == "" ? color : hrefColor == null ? const Color(0xFF0000EE) : hrefColor);
  }

  TextSpan render() {
    if (href != null && href != "") {
      return TextSpan(
          text: this.text,
          style: _getStyle(),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch(href);
            });
    } else {
      return TextSpan(text: this.text, style: _getStyle());
    }
  }
}
