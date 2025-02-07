import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v/widgets/custom_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Secret Pixel', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 10,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            SizedBox(
              height: height / 20,
            ),
            Text(
              'Send Your Secret Message Through Image',
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: height / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.grey.shade800,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70)),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height / 25,
                  ),
                  Text(
                    'Get Started!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.lock,
                          color: Colors.white, size: 40),
                      SizedBox(width: 20),
                      Icon(FontAwesomeIcons.image,
                          color: Colors.white, size: 40),
                      SizedBox(width: 20),
                      Icon(FontAwesomeIcons.unlock,
                          color: Colors.white, size: 40),
                    ],
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  SizedBox(
                      height: 130,
                      child: Image.asset('assets/images/silent.png')),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          isOpenOnStart: true,
          iconTheme: IconThemeData(color: Colors.black),
          // animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(color: Colors.black),
          // visible: true,
          // curve: Curves.bounceIn,
          backgroundColor: Colors.white,
          children: [
            SpeedDialChild(
              child: Icon(FontAwesomeIcons.unlock),
              onTap: () {
                Navigator.pushNamed(context, '/revealMsg');
              },
              label: 'Decode Message',
              labelStyle: TextStyle(color: Colors.black),
              labelBackgroundColor: Colors.white,
            ),
            SpeedDialChild(
              child: Icon(FontAwesomeIcons.lock),
              onTap: () {
                Navigator.pushNamed(context, '/hideMsg');
              },
              label: 'Encode Message',
              labelStyle: TextStyle(color: Colors.black),
              labelBackgroundColor: Colors.white,
            ),
          ],
        ));
  }
}
