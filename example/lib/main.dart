import 'package:coordinator_layout/coordinator_layout.dart';
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
        useMaterial3: false,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

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
    double headerMinHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    return Scaffold(
      body: CoordinatorLayout(
        headerMaxHeight: headerMinHeight + 80,
        headerMinHeight: headerMinHeight,
        headers: [
          Builder(builder: (context) {
            return SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverCollapsingHeader(
                  builder: (context, offset, diff) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 0),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Stack(
                          children: <Widget>[
                            Opacity(
                              opacity: offset,
                              child: Container(
                                margin: EdgeInsets.only(top: headerMinHeight * (offset)),
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text("Point : 30,200"),
                                    ),
                                    FloatingActionButton.extended(
                                      backgroundColor: Colors.green,
                                      onPressed: () {},
                                      label: Text("View"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AppBar(
                              title: Text("Home"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          })
        ],
        body: ListView.builder(
            itemCount: 1, itemBuilder: (context, index) => Container(height: null, child: buildBody(context))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Center buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
