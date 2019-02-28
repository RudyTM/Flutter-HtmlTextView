
import 'package:flutter/material.dart';
import 'package:flutter_htmltextview/html_node.dart';

class HtmlContainer {
  static const int P = 0;
  static const int H1 = 1;
  static const int H2 = 2;
  static const int H3 = 3;
  static const int H4 = 4;
  static const int H5 = 5;
  static const int H6 = 6;
  static const int A = 7;

  static int toIdFromTag(String tag) {
    switch (tag) {
      case "p":
        return P;
      case "a":
        return A;
      case "h1":
        return H1;
      case "h2":
        return H2;
      case "h3":
        return H3;
      case "h4":
        return H4;
      case "h5":
        return H5;
      case "h6":
        return H6;
    }
  }

  static bool isContainer(String tag) {
    return tag == "p" ||
        tag == "h1" ||
        tag == "h2" ||
        tag == "h3" ||
        tag == "h4" ||
        tag == "h5" ||
        tag == "h6" ||
    tag == "a";
  }

  int type;
  Color color;
  final String style;
  Map<dynamic, dynamic> attributesForChildren = {};
  List<dynamic> nodes;

  TextAlign textAlign;

  HtmlContainer(
      {this.type, this.textAlign = TextAlign.left, this.style, this.color});

  Widget render() {
    List<Widget> contents = new List();
    nodes.forEach((node) {
      if (node is HtmlContainer) {
        node.parseStyle();
        contents.add(renderPContents(node, new List()));
      } else {
        contents.add(Text(
          (node as HtmlNode).text,
          style: TextStyle(fontSize: 4),
        ));
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: contents,
    );
  }

  parseStyle() {
    if (style != "") {
      List<String> styles = style.split(";");
      if (styles.length != 0) {
        Map stylesMap = new Map();
        styles.forEach((item) {
          if (item != "") {
            stylesMap.addAll({
              item.split(":")[0].trimLeft().trimRight():
                  item.split(":")[1].trimLeft().trimRight()
            });
          }
        });

        if (stylesMap.containsKey("text-align")) {
          if (stylesMap["text-align"].toString().contains("center")) {
            textAlign = TextAlign.center;
          } else if (stylesMap["text-align"].toString().contains("right")) {
            textAlign = TextAlign.right;
          } else {
            textAlign = TextAlign.left;
          }
        }

        if (stylesMap.containsKey("color")) {
          color = parseColor(stylesMap["color"]);
        } else {
          color = null;
        }
      }
    }
  }

  static dynamic parseStyleToMap(String style) {
    if (style != null && style != "") {
      List<String> styles = style.split(";");
      if (styles.length != 0) {
        Map stylesMap = new Map();
        styles.forEach((item) {
          if (item != "") {
            stylesMap.addAll({
              item.split(":")[0].trimLeft().trimRight():
                  item.split(":")[1].trimLeft().trimRight()
            });
          }
        });
        return stylesMap;
      }
    }

    return null;
  }

  static String styleToString(Map<dynamic, dynamic> style) {
    String map = "";
    style.forEach((key, value) {
      map += "$key: $value;";
    });

    return map;
  }

  static Color parseColor(String color) {
    try {
      if (color != "") {
        var tmp = color.replaceAll('#', '').trim();
        return Color(int.parse('0xFF' + tmp));
      } else {
        return const Color(0xFF000000);
      }
    } catch (ex) {
      return const Color(0xFF000000);
    }
  }

  static dynamic parseElementInStyle(String style, String key) {
    if (style != "") {
      List<String> styles = style.split(";");
      if (styles.length != 0) {
        Map stylesMap = new Map();
        styles.forEach((item) {
          if (item != "") {
            stylesMap.addAll({
              item.split(":")[0].trimLeft().trimRight():
                  item.split(":")[1].trimLeft().trimRight()
            });
          }
        });
        if (stylesMap.containsKey(key)) {
          return stylesMap[key];
        } else {
          return "";
        }
      }
    }

    return "";
  }

  double getFontSize() {
    switch (type) {
      case P:
        return 16.0;
      case H6:
        return 11.5;
      case H5:
        return 13.0;
      case H4:
        return 16.0;
      case H3:
        return 20.0;
      case H2:
        return 24.0;
      case H1:
        return 32.0;
    }
  }

  Widget renderPContents(HtmlContainer root, List<TextSpan> contents) {

    root.nodes.forEach((node) {
      if(node is HtmlNode) {
        contents.add(node.render());
      }else{
        renderPContents(node, contents);
      }
    });

    TextSpan span = TextSpan(children: contents);
    root.parseStyle();
    return RichText(
      text: span,
      textAlign: root.textAlign,
    );
  }
}
