import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<String> _loadData() async {
    await Future.delayed(Duration(seconds: 2));
    return "Data Loaded Successfully!";
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: FutureBuilder(
      //   future: _loadData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData){
      //     return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else {
      //       return Center(child: Text(snapshot.data!));
      //     }
      //   },
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/mu_bg.png',
            fit: BoxFit.fill
          ),
          Center(
            child: Image.asset(
              'assets/mu_logo_slogan.png',
              height: 250,
              width: 250,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}