import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/count.dart';

abstract class DashboardRepository {
  Future<List<CountMetric>> fetchMetrics();
}

class InMemoryDashboardRepository implements DashboardRepository {
  @override
  Future<List<CountMetric>> fetchMetrics() async {
    return const [
      CountMetric(label: 'MR', value: 0, icon: Icons.groups_rounded),
      CountMetric(label: 'ASM', value: 0, icon: Icons.manage_accounts_rounded),
      CountMetric(
        label: 'Visual Ads',
        value: 0,
        icon: Icons.view_carousel_rounded,
      ),
      CountMetric(
        label: 'Doctors',
        value: 0,
        icon: Icons.medical_services_rounded,
      ),
      CountMetric(label: 'Chemist Shops', value: 0, icon: Icons.store_rounded),
      CountMetric(
        label: 'Distributors',
        value: 0,
        icon: Icons.inventory_2_rounded,
      ),
      CountMetric(label: 'Teams', value: 0, icon: Icons.hub_rounded),
      CountMetric(
        label: 'Orders Pending',
        value: 0,
        icon: Icons.pending_actions_rounded,
      ),
      CountMetric(
        label: 'Orders Shipped',
        value: 0,
        icon: Icons.local_shipping_rounded,
      ),
      CountMetric(
        label: 'Orders Delivered',
        value: 0,
        icon: Icons.task_alt_rounded,
      ),
      CountMetric(
        label: 'Leaves Pending',
        value: 0,
        icon: Icons.event_busy_rounded,
      ),
    ];
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return InMemoryDashboardRepository();
});
