import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'package:v/new/decode_page.dart';
import 'package:v/new/drawer_custom.dart';
import 'package:v/new/encode_page.dart';

class NewHomeView extends StatefulWidget {
  @override
  _NewHomeViewState createState() => _NewHomeViewState();
}

class _NewHomeViewState extends State<NewHomeView> {
  double currentIndexPage = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  // function to jump to a specific page
  void jumpToPage(int page) {
    _pageController.animateToPage(
      page,
      duration:
          Duration(milliseconds: 500), // Set the duration of the animation
      curve: Curves.easeInOut, // Set the curve of the animation
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print('build is called');
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              DotsIndicator(
                dotsCount: 3,
                position: currentIndexPage.toInt(),
                decorator: DotsDecorator(
                  activeColor: Colors.white,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              Expanded(
                  child: PageView(
                controller: _pageController,
                hitTestBehavior: HitTestBehavior.translucent,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (val) {
                  setState(() {
                    currentIndexPage = val.toDouble();
                  });
                },
                children: [
                  DrawerCustom(
                    jumpTo: (val) {
                      jumpToPage(val);
                    },
                  ),
                  EncodePage(
                    jumpTo: (val) {
                      jumpToPage(val);
                    },
                  ),
                  DecodePage.DecodePage(
                    jumpTo: (val) {
                      jumpToPage(val);
                    },
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
