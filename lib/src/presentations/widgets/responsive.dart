import 'package:flutter/material.dart';

//Custom Responsive 
class ResponsiveWidget extends StatelessWidget {
  final Widget? largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveWidget(
      {super.key,
      required this.largeScreen,
      this.mediumScreen,
      this.smallScreen});

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 700 &&
        MediaQuery.of(context).size.width <= 1200;
  }

  static bool isCustomSize(BuildContext context) {
    return MediaQuery.of(context).size.width <= 1100 &&
        MediaQuery.of(context).size.width >= 768;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen!;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 700) {
          return mediumScreen ?? largeScreen!;
        } else {
          return smallScreen ?? largeScreen!;
        }
      },
    );
  }
}
