import 'dart:ui';


import 'package:flutter_htmltextview/html_container.dart';
import 'package:flutter_htmltextview/html_node.dart';
import 'package:html/dom.dart' as dom;

class HtmlParser {
  final String customFont;
  final String customFontBold;
  final Color anchorColor;
  final String data;

  HtmlParser({this.data, this.customFont, this.customFontBold, this.anchorColor});

  HtmlContainer parse() {
    String aux = "<div>$data</div>";
    dom.Element root = dom.Element.html(aux.replaceAll("&nbsp;", " ").replaceAll("\n", "").replaceAll("\r", "").replaceAll("<br/>", "\n").replaceAll("</br>", "\n"));
    HtmlContainer nodesToRender = HtmlContainer()..nodes = new List();

    _buildNodesToRender(root, nodesToRender, attributesForChildren: {});

    return nodesToRender;
  }

  dynamic _buildNodesToRender(dom.Element parent, HtmlContainer containerToAdd,
      {Map<dynamic, dynamic> attributesForChildren}) {
    parent.nodes.forEach((node) {
      var local;
      try {
        local = (node as dom.Element).localName;
      } catch (ex) {
        local = null;
      }
      if (local == null) {
        var newList = {};

        if (attributesForChildren != null) {
          if (newList == null) {
            newList = attributesForChildren;
          } else {
            newList.addEntries(attributesForChildren.entries);
          }
        }

        String style = "";

        if (node.attributes.containsKey("style")) {
          style = node.attributes["style"];
        } else {
          if (attributesForChildren != null &&
              attributesForChildren.containsKey("style")) {
            style = attributesForChildren["style"];
          }
        }

        if (style != "") {
          Map parentStyle =
              HtmlContainer.parseStyleToMap(attributesForChildren["style"]);
          Map childStyle =
              HtmlContainer.parseStyleToMap(node.attributes["style"]);

          if (childStyle != null && childStyle.containsKey("color")) {
            if (parentStyle != null && !parentStyle.containsKey("color")) {
              parentStyle.addAll({"color": childStyle});
            } else {
              parentStyle["color"] = childStyle["color"];
            }
          }

          style = HtmlContainer.styleToString(parentStyle);
        }

        containerToAdd.nodes.add(new HtmlNode(
            parent: containerToAdd,
            fontFamily: this.customFont,
            fontFamilyBold: this.customFontBold,
            color: style != null && style != ""
                ? HtmlContainer.parseColor(
                    HtmlContainer.parseElementInStyle(style, "color"))
                : const Color(0xFF000000),
            text: node
                .toString()
                .substring(1, node.toString().length - 1)
                .replaceAll("&nbsp;", " "),
            textAttributes: newList,
            fontSize: containerToAdd.getFontSize(),
            hrefColor: anchorColor,
            href: attributesForChildren.containsKey("href")
                ? attributesForChildren["href"]
                : ""));
      }
      if (node.hasChildNodes()) {
        if (node.attributes != null && node.attributes.length != 0) {
          if (node.attributes.containsKey("href")) {
            attributesForChildren.addAll({"href": node.attributes["href"]});
          }
        }

        if (local != null && (local == "strong" || local == "b")) {
          attributesForChildren.addAll({"bold": 1});
        } else if (local != null && (local == "em" || local == "i")) {
          attributesForChildren.addAll({"italic": 1});
        }

        var newContainer;
        if (HtmlContainer.isContainer(local)) {
          String style = "";
          if (node.attributes.containsKey("style")) {
            style = node.attributes["style"];
          }

          var newList = {};
          Map parentStyle;
          Map childStyle;

          if (attributesForChildren != null &&
              attributesForChildren.length != 0) {
            if(attributesForChildren.containsKey("style")){
              parentStyle = HtmlContainer.parseStyleToMap(attributesForChildren["style"]);
            }
            if (newList == null) {
              newList = attributesForChildren;
            } else {
              newList.addEntries(attributesForChildren.entries);
            }
          } else {}

          if (style != null && style != "") {
            childStyle = HtmlContainer.parseStyleToMap(style);
            //newList.addAll({"style": style});
          }

          if(parentStyle == null || parentStyle.length == 0){
            newList.addAll({"style": style});
          }else{
            String mergeStyle;
            if(childStyle != null) {
              childStyle.forEach((key, value) {
                if (parentStyle.containsKey(key)) {
                  parentStyle[key] = value;
                } else {
                  parentStyle.addAll({key: value});
                }
              });
            }
            mergeStyle = HtmlContainer.styleToString(parentStyle);
            newList.addAll({"style": mergeStyle});
          }

          newContainer = new HtmlContainer(
              type: HtmlContainer.toIdFromTag(local), style: style);
          newContainer.parseStyle();
          newContainer.nodes = new List();
          attributesForChildren = newList;
          containerToAdd.nodes.add(newContainer);
        } else {
          String style = "";
          if (node.attributes.containsKey("style")) {
            style = node.attributes["style"];

            //TODO OVERRIDE STYLES
            attributesForChildren.addAll({"style": style});
          }
        }

        var tmp = _buildNodesToRender(
            node, newContainer != null ? newContainer : containerToAdd,
            attributesForChildren: attributesForChildren);

        _clearAttributes((tmp["element"] as dom.Element).localName, attributesForChildren);
        //attributesForChildren.remove("style");
        if (tmp["container"] is HtmlContainer) {
          attributesForChildren.addEntries((tmp["container"] as HtmlContainer)
              .attributesForChildren
              .entries);

            attributesForChildren.remove("href");

        }
      }
    });

    return {"element": parent, "container": containerToAdd};
  }

  static _clearAttributes(
      String local, Map<dynamic, dynamic> attributesForChildren) {
    switch (local) {
      case "em":
      case "i":
        return attributesForChildren.remove("italic");
      case "b":
      case "strong":
        return attributesForChildren.remove("bold");
      case "a":
        return attributesForChildren.remove("href");
    }
  }
}
