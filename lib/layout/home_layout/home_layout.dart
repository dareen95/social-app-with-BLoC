import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/layout/home_layout/home_layout_provider.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<HomeLayoutProvider>(context, listen: false).checkEmailVerified();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeLayoutProvider>(
      builder: (context, homeLayoutProvider, _) => Scaffold(
        appBar: AppBar(
          title: Text(homeLayoutProvider.titles[homeLayoutProvider.currentIndex]),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications)), IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Center(child: Text('POST', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.0))),
          elevation: 3.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: !homeLayoutProvider.isEmailVerified
            ? null
            : BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 5.0,
                elevation: 5.0,
                child: BottomNavigationBar(
                  backgroundColor: Colors.white.withAlpha(0),
                  elevation: 0.0,
                  items: homeLayoutProvider.items,
                  currentIndex: homeLayoutProvider.currentIndex,
                  onTap: (index) => homeLayoutProvider.changeBottomNavIndex(index),
                ),
              ),
        body: !homeLayoutProvider.isEmailVerified
            ? TextButton(
                onPressed: () async {
                  final result = await homeLayoutProvider.verifyEmailAddress();
                  if (result == 'success') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('check your email')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: Text('verify your email to access the app'))
            : homeLayoutProvider.screens[homeLayoutProvider.currentIndex],
      ),
    );
  }
}
