# flutter_html_text_view

Flutter package for rendering html tags as a TextView; It was created
because of the lack of transforming simple htmls with text into a
textview or a webview

## How to use
HtmlTextView is a widget, so it can be a child of any widget. It has
support for using custom font from the assets folder, the anchors can be
set to an specified color

``` 
HtmlTextView( data: "<div style='color: #7B7B7B;'><h1>Testing the
control</h1> <p>A lorem ipsum to <b>fill the gap</b></p><a
href="http://flutter.com"> Or it can be a link</a></div>", customFont:
"font in your assets declared in your project", customFontBold: "font in
your assets declared in your project", anchorColor: Color(0xFFFF0000),
));
```

## Supported tags
- a 
- strong 
- em 
- h1 
- h2 
- h3 
- h4 
- h5 
- h6 
- p

## Supported elements in style
- href - for anchors
- text-align; left, center and right 
- color; default color is black