import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../providers/profile_provider.dart';

class ProfileNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    final repo = ref.read(profileRepositoryProvider);
    return repo.load();
  }
}

final profileNotifierProvider = AsyncNotifierProvider<ProfileNotifier, User>(
  ProfileNotifier.new,
);
