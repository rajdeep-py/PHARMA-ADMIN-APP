import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/terms_conditions.dart';

abstract class TermsConditionsRepository {
  Future<List<TermsCondition>> fetchTerms();
}

class InMemoryTermsConditionsRepository implements TermsConditionsRepository {
  @override
  Future<List<TermsCondition>> fetchTerms() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    return const [
      TermsCondition(
        header: 'Acceptance of Terms',
        description:
            'By accessing or using this admin application, you agree to follow these Terms & Conditions. If you do not agree, please discontinue use.',
      ),
      TermsCondition(
        header: 'Admin Responsibilities',
        description:
            'You are responsible for maintaining the confidentiality of access and for all actions performed under your account in this app.',
      ),
      TermsCondition(
        header: 'Data Accuracy',
        description:
            'Ensure that MR/ASM, doctor, chemist, distributor, and order information entered in the system is accurate and up to date.',
      ),
      TermsCondition(
        header: 'Usage Limits',
        description:
            'Do not misuse the application, attempt to bypass security controls, or use the app in a way that may disrupt services or other users.',
      ),
      TermsCondition(
        header: 'Privacy & Compliance',
        description:
            'You must comply with applicable company policies and local regulations while managing team and field data within the platform.',
      ),
      TermsCondition(
        header: 'Changes to Terms',
        description:
            'Terms may be updated periodically. Continued use of the application after updates indicates acceptance of the revised terms.',
      ),
    ];
  }
}

final termsConditionsRepositoryProvider = Provider<TermsConditionsRepository>((
  ref,
) {
  return InMemoryTermsConditionsRepository();
});
