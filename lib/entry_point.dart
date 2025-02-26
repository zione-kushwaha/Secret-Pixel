import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/view/decode/decode_view.dart';
import '/view/encode/encode_page.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/information_constant.dart';
import 'view/information/infomation_view.dart';

class EntryPoint extends ConsumerStatefulWidget {
  const EntryPoint({super.key});

  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends ConsumerState<EntryPoint> {
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
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return ThemeSwitchingArea(
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                _buildDotsIndicator(),
                _buildPage(index: currentIndexPage.toInt()),
                _buildBottomCarousel(height, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // building the dots indicator
  Widget _buildDotsIndicator() {
    return DotsIndicator(
      animate: true,
      dotsCount: 3,
      position: currentIndexPage,
      decorator: DotsDecorator(
        activeColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        size: const Size.square(9.0),
        activeSize: const Size(18.0, 9.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  // build the Expanded pages
  Widget _buildPage({required int index}) {
    return Expanded(
      child: PageView(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            currentIndexPage = page.toDouble();
          });
        },
        children: [
          // Page 1
          InformationView(jumpTo: jumpToPage),
          // Page 2
          EncodePage(jumpTo: jumpToPage),
          // Page 3
          DecodePage(jumpTo: jumpToPage)
        ],
      ),
    );
  }

  Widget _buildBottomCarousel(double height, double width) {
    return CarouselSlider(
      options: CarouselOptions(
        height: height / 10,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),
      items: messages.asMap().entries.map((entry) {
        // int index = entry.key;
        String message = entry.value;
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0.5), // changes position of shadow
                  ),
                ],
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(images[index], width: 24, height: 24),
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
