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
        child: MyGridWidget(
          minCount: 2,
          maxCount: 8,
          showCount: 5,
        ),
      ),
    );
  }
}

class MyGridWidget extends StatefulWidget {
  final int minCount;
  final int maxCount;
  final int showCount;
  final Duration duration;
  MyGridWidget({
    Key key,
    this.minCount = 1,
    this.duration = const Duration(seconds: 2),
    this.maxCount = 8,
    this.showCount = 5,
  }) : super(key: key);

  @override
  _MyGridWidgetState createState() => _MyGridWidgetState();
}

class _MyGridWidgetState extends State<MyGridWidget> {
  double scale = 1.0;

  int showCount;

  @override
  void initState() {
    super.initState();
    showCount = widget.showCount;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails details) {
        // print("手势倍数量： ${details.scale}");
        setState(() {
          scale = details.scale;
          // if (showCount.toDouble() * scale == widget.maxCount.toDouble()) {
          //   print(
          //       "超出边界了 showCount.toDouble() * scale is ${showCount.toDouble() * scale}  widget.maxCount.toDouble() is ${widget.maxCount.toDouble()} ");
          //   scale = 1.0;
          // }
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        setState(() {
          showCount = showCount ~/ scale;

          if (showCount < widget.minCount) {
            showCount = widget.minCount;
          } else if (showCount >= widget.maxCount) {
            showCount = widget.maxCount;
          }

          scale = 1.0;
        });
      },
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scale: (widget.maxCount.toDouble() / showCount.toDouble()) * scale,
        child: AnimatedSwitcher(
          duration: widget.duration,
          child: GridView.builder(
            clipBehavior: Clip.none,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.maxCount),
            itemBuilder: (BuildContext context, int index) {
              int rowCount = index % widget.maxCount;

              var itemIndex =
                  ((index ~/ widget.maxCount) * showCount).toInt() + rowCount;
              // print(
              //     "index is $index  rowcount is ： ${rowCount}  (index / widget.maxCount) * showCount) is ${index ~/ widget.maxCount * showCount}");
              return AnimatedSwitcher(
                duration: widget.duration,
                child: rowCount > showCount
                    ? Container() // 屏幕外的内容
                    : Container(
                        key: ValueKey(itemIndex),
                        color: Colors
                            .primaries[itemIndex % Colors.primaries.length],
                        child: Center(child: Text("$itemIndex")),
                      ),
              );
              // return rowCount > showCount
              //     ? Container() // 屏幕外的内容
              //     : Container(
              //         key: ValueKey(itemIndex),
              //         color:
              //             Colors.primaries[itemIndex % Colors.primaries.length],
              //         child: Center(child: Text("$itemIndex")),
              //       );
            },
          ),
        ),
      ),
    );
  }
}
