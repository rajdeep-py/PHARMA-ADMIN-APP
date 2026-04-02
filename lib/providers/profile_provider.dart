import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../notifiers/auth_notifier.dart';

abstract class ProfileRepository {
  Future<User> load();
}

class InMemoryProfileRepository implements ProfileRepository {
  InMemoryProfileRepository(this.ref);

  final Ref ref;

  @override
  Future<User> load() async {
    final signedInUser = ref
        .read(authNotifierProvider)
        .maybeWhen(data: (u) => u, orElse: () => null);
    if (signedInUser != null) return signedInUser;

    return const User(
      companyName: 'Demo Company',
      phoneNumber: '0000000000',
      email: 'demo@company.com',
      cinNumber: 'N/A',
      gstNumber: null,
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return InMemoryProfileRepository(ref);
});
