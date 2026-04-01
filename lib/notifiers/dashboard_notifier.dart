import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/count.dart';
import '../providers/dashboard_provider.dart';

typedef DashboardMetrics = List<CountMetric>;

final dashboardNotifierProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardMetrics>(
      DashboardNotifier.new,
    );

class DashboardNotifier extends AsyncNotifier<DashboardMetrics> {
  @override
  Future<DashboardMetrics> build() async {
    final repo = ref.read(dashboardRepositoryProvider);
    return repo.fetchMetrics();
  }
}
