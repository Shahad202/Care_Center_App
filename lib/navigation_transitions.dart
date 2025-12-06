import 'package:flutter/material.dart';

// Common slide+fade route for lightweight page transitions across the app.
PageRouteBuilder<T> slideUpRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, animation, secondaryAnimation) => page,
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
      final offsetTween = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero);
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
      return SlideTransition(
        position: offsetTween.animate(curved),
        child: FadeTransition(
          opacity: fadeTween.animate(curved),
          child: child,
        ),
      );
    },
  );
}
