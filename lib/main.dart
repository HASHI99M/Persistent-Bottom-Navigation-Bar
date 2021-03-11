import 'package:flutter/material.dart';
import 'tab_navigator.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentPage = "Page1";
  List<String> pageKeys = ["Page1", "Page2", "Page3"];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 0;

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Page1") {
            _selectTab("Page1", 1);
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children:<Widget>[
            _buildOffstageNavigator("Page1"),
            _buildOffstageNavigator("Page2"),
            _buildOffstageNavigator("Page3"),
          ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) { _selectTab(pageKeys[index], index); },
          currentIndex: _selectedIndex, 
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.looks_one),
              title: new Text('Page1'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.looks_two),
              title: new Text('Page2'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.looks_3),
              title: new Text('Page3'),
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),    
    );
  }


    Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}



class Page1 extends StatefulWidget {
  const Page1({Key key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1>  with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 1"),
        actions:<Widget>[
          IconButton(icon: Icon(Icons.ac_unit), onPressed: (){
            Navigator.push(
              context,
              new MaterialPageRoute( 
                  builder: (BuildContext context) =>
                  new ListViewPage()));

          })
        ]
      ),
      body: Align(
        alignment: Alignment.center,
        child: FlatButton(color: Colors.blue, textColor: Colors.white, onPressed: (){
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                  new ListViewPage()));
        }, child: Text("Switch Page - Subscribe")))
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Page2 extends StatelessWidget {
  const Page2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Page 2"),
        actions:<Widget>[
          IconButton(icon: Icon(Icons.ac_unit), onPressed: (){
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new Page2()));

          })
        ]
      ),
      body: Align(
        alignment: Alignment.center,
        child: FlatButton(color: Colors.blue, textColor: Colors.white, onPressed: (){
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                  new ListViewPage()));
        }, child: Text("Switch Page - Leave a Like")))
      ));
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Page 3"),
        actions:<Widget>[
          IconButton(icon: Icon(Icons.ac_unit), onPressed: (){
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new Page2()));

          })
        ]
      ),
      body: Align(
        alignment: Alignment.center,
        child: FlatButton(color: Colors.blue, textColor: Colors.white, onPressed: (){
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                  new ListViewPage()));
        }, child: Text("Switch Page - Comment")))
      ));
  }
}

class ListViewPage extends StatelessWidget {
  const ListViewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Infinite List"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(leading: Text("$index"), title: Text("Number $index"));
        },
      ),
    );
  }
}