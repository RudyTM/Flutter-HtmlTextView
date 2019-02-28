import 'package:flutter/material.dart';
import 'package:flutter_htmltextview/html_text_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String html = "";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String html = "<h1 style='text-align: center'>H1 centered</h1>" +
        "</br></br>"
        "<p style='color: #000000'>Hello World after line breaks and with custom color.</p>" +
        "<h2 style='text-align: right'>H2 aligned to the right with parent color</h2>" +
        "<a href='http://www.pixzelle.mx'>An anchor with the color established in the construction</a>" +
        "<p>This is an example of a <strong><a href='http://pixzelle.mx'>multiline p with various tags</a></strong>, it supports <em>italic</em>," +
        "<strong>bold</strong>, <em><strong>combinations</strong></em>, <a href='http://www.pixzelle.mx'>anchors</a>.</p><br/>" +
        "<p>We also can combine <a href='http://pixzelle.mx'><strong><em>Anchors with bold and italic</em></strong></a>." +
        "<p style='text-align: center; color: #00FF00'>" +
        "For styles, for the moment only text-alignment(left, center and right) and color for the font(HEX: #00FF00)." +
        "</p>";
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
          margin: EdgeInsets.all(16.0),
          child: HtmlTextView(
            data: "<div style='color: #0000ff'>$html</div>",
            anchorColor: Color(0xFFFF0000),
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
