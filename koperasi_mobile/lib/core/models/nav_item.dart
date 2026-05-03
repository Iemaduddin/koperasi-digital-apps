import 'package:flutter/material.dart';

class SubItem {
  final String label;
  final IconData icon;
  final Widget page;

  SubItem({
    required this.label,
    required this.icon,
    required this.page,
  });
}

class NavigationItem {
  final String label;
  final IconData icon;
  final Widget? page;
  final List<SubItem>? children;

  NavigationItem({
    required this.label,
    required this.icon,
    this.page,
    this.children,
  });

  bool get hasChildren => children != null && children!.isNotEmpty;
}
