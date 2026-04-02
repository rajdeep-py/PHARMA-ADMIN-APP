import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/terms_conditions.dart';
import '../providers/terms_conditions_provider.dart';

final termsConditionsNotifierProvider =
    AsyncNotifierProvider<TermsConditionsNotifier, List<TermsCondition>>(
      TermsConditionsNotifier.new,
    );

class TermsConditionsNotifier extends AsyncNotifier<List<TermsCondition>> {
  @override
  Future<List<TermsCondition>> build() async {
    final repo = ref.read(termsConditionsRepositoryProvider);
    return repo.fetchTerms();
  }
}
