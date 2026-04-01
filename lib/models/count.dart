import 'package:flutter/material.dart';

@immutable
class CountMetric {
  const CountMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;
}
