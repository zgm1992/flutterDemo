import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AnimatedCountButton(
              width: 100,
              height: 100,
              radius: 20,
            ),
            AnimatedCountButton(
              width: 100,
              height: 100,
              radius: 0,
            ),
            AnimatedCountButton(
              width: 100,
              height: 100,
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCountButton extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final Duration duration;

  const AnimatedCountButton({
    Key key,
    this.width,
    this.height,
    this.duration = const Duration(seconds: 8),
    this.radius,
  }) : super(key: key);

  @override
  _AnimatedCountButtonState createState() => _AnimatedCountButtonState();
}

class _AnimatedCountButtonState extends State<AnimatedCountButton> {
  var isCancel = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isCancel ? Colors.lightGreenAccent : Colors.blue[300],
      elevation: 4,
      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
      child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          onTap: () {
            setState(() {
              isCancel = !isCancel;
            });
          },
          child: isCancel
              ? TweenAnimationBuilder(
                  tween: Tween(begin: 50.0, end: 450.0),
                  duration: widget.duration,
                  onEnd: () {
                    setState(() {
                      isCancel = !isCancel;
                    });
                  },
                  builder: (BuildContext context, Object value, Widget child) {
                    return Container(
                      key: UniqueKey(),
                      height: widget.height,
                      width: widget.width,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(widget.radius)),
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.red[500], width: 4)),
                      ),
                      foregroundDecoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(widget.radius)),
                        border: MyBorder.fromBorderSide(
                            BorderSide(color: Colors.red[200], width: 4),
                            progress: value),
                      ),
                      child: Center(child: Text("点我取消")),
                    );
                  },
                )
              : Container(
                  height: widget.height,
                  width: widget.width,
                  // decoration: BoxDecoration(
                  //   color: Colors.yellow[300],
                  //   borderRadius:
                  //       BorderRadius.all(Radius.circular(widget.radius)),
                  // ),
                  child: Center(child: Text("我是button")),
                )),
    );
  }
}

class MyBorder extends Border {
  double progress;

  MyBorder.fromBorderSide(BorderSide side, {this.progress})
      : super(top: side, right: side, bottom: side, left: side);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius borderRadius,
  }) {
    print("rect is $rect progress is $progress  ");

    var path;
    //通过裁剪的方式，实现进度效果
    if (progress < 100.0) {
      path = createPathStep1(rect, progress);
    } else if (progress < 200.0) {
      path = createPathStep2(rect, progress - 100);
    } else if (progress < 300.0) {
      path = createPathStep3(rect, progress - 200);
    } else if (progress < 400.0) {
      path = createPathStep4(rect, progress - 300);
    } else {
      path = createPathStep5(rect, progress - 400);
    }
    canvas.save();
    if (path != null) {
      canvas.clipPath(path);
    }

    super.paint(
      canvas,
      rect,
      textDirection: textDirection,
      shape: shape,
      borderRadius: borderRadius,
    );
    canvas.restore();
  }

  Path createPathStep1(Rect rect, value) {
    var size = rect.size;
    var centerX = rect.left + size.width / 2;
    var centerY = rect.top + size.height / 2;
    var path = Path();
    path.moveTo(centerX, centerY);
    path.lineTo(rect.left + value / 100 * size.width, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.top);
    path.lineTo(centerX, rect.top);
    path.close();
    return path;
  }

  Path createPathStep2(Rect rect, value) {
    print("step2 the value is $value");
    var size = rect.size;
    var centerX = rect.left + size.width / 2;
    var centerY = rect.top + size.height / 2;
    var path = Path();
    path.moveTo(centerX, centerY);
    path.lineTo(rect.right, rect.top + value / 100 * size.height);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.top);
    path.lineTo(centerX, rect.top);
    path.close();
    return path;
  }

  Path createPathStep3(Rect rect, value) {
    var size = rect.size;
    var centerX = rect.left + size.width / 2;
    var centerY = rect.top + size.height / 2;
    var path = Path();
    path.moveTo(centerX, centerY);
    path.lineTo(rect.right - value / 100 * size.width, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.top);
    path.lineTo(centerX, rect.top);
    path.close();
    return path;
  }

  Path createPathStep4(Rect rect, value) {
    var size = rect.size;
    var centerX = rect.left + size.width / 2;
    var centerY = rect.top + size.height / 2;
    var path = Path();
    path.moveTo(centerX, centerY);
    path.lineTo(rect.left, rect.bottom - size.height * value / 100);
    path.lineTo(rect.left, rect.top);
    path.lineTo(centerX, rect.top);
    path.close();
    return path;
  }

  Path createPathStep5(Rect rect, value) {
    var size = rect.size;
    var centerX = rect.left + size.width / 2;
    var centerY = rect.top + size.height / 2;
    var path = Path();
    path.moveTo(centerX, centerY);
    path.lineTo(rect.left + value / 100 * size.width, rect.top);
    path.lineTo(centerX, rect.top);
    path.close();
    return path;
  }
}
