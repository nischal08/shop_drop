import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      //Fade transition of navigation to initial route screen
      return child;
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// class CustomPageTransitionBuilder extends PageTransitionsBuilder {
//   @override//Fade transition of navigation to all screen
//   Widget buildTransitions<T>(
//     BuildContext context,
//     Animation<double> animation,
//     PageRoute<T> route,
//     Animation<double> secondaryAnimation,
//     Widget child,
//   ) {
//     if (route.settings.name == '/') {
//       return child;
//     }

//     return FadeTransition(
//       opacity: animation,
//       child: child,
//     );
//   }
// }
