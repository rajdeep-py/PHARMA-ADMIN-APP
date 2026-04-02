import 'package:flutter/foundation.dart';

@immutable
class TermsCondition {
  const TermsCondition({required this.header, required this.description});

  final String header;
  final String description;
}
