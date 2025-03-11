import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sportpro/intro_pages/page1.dart';
import 'package:sportpro/intro_pages/page2.dart';
import 'package:sportpro/intro_pages/page3.dart';
import 'package:sportpro/login.dart';

class Onboardscreen extends StatefulWidget {
  const Onboardscreen({super.key});

  @override
  State<Onboardscreen> createState() => _OnboardscreenState();
}

class _OnboardscreenState extends State<Onboardscreen> {
  PageController controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.jumpToPage(const Login() as int);
                  },
                  child: const Text("skip")
                ),
                SmoothPageIndicator(
                  controller: controller, 
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.blueGrey,
                    dotColor: Colors.grey,
                    dotHeight: 25,
                    dotWidth: 25
                  ),
                ),
                onLastPage
                ? GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const Login();
                      })
                    );
                  },
                  child: const Text("start")
                ) 
                : GestureDetector(
                  onTap: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text("next"),
                ) 
              ],
            ),
          )
        ],
      )
    );
  }
}