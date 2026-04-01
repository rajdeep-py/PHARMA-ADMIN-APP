import 'package:flutter/material.dart';

enum SideNavDestination {
  dashboard,
  mrManagement,
  asmManagement,
  teamManagement,
  visualAdsManagement,
  attendanceRecords,
  dcr,
  tripPlanManagement,
  orderManagement,
  distributorManagement,
  chemistShopManagement,
  salarySlipManagement,
  notifications,
  profile,
  aboutUs,
  helpCenter,
}

extension SideNavDestinationX on SideNavDestination {
  String get label {
    switch (this) {
      case SideNavDestination.dashboard:
        return 'Dashboard';
      case SideNavDestination.mrManagement:
        return 'MR Management';
      case SideNavDestination.asmManagement:
        return 'ASM Management';
      case SideNavDestination.teamManagement:
        return 'Team Management';
      case SideNavDestination.visualAdsManagement:
        return 'Visual Ads Management';
      case SideNavDestination.attendanceRecords:
        return 'Attendance Records (MR and ASM)';
      case SideNavDestination.dcr:
        return 'DCR';
      case SideNavDestination.tripPlanManagement:
        return 'Trip Plan Management';
      case SideNavDestination.orderManagement:
        return 'Order Management';
      case SideNavDestination.distributorManagement:
        return 'Distributor Management';
      case SideNavDestination.chemistShopManagement:
        return 'Chemist Shop Management';
      case SideNavDestination.salarySlipManagement:
        return 'Salary Slip Management';
      case SideNavDestination.notifications:
        return 'Notifications';
      case SideNavDestination.profile:
        return 'Profile';
      case SideNavDestination.aboutUs:
        return 'About Us';
      case SideNavDestination.helpCenter:
        return 'Help Center';
    }
  }

  IconData get icon {
    switch (this) {
      case SideNavDestination.dashboard:
        return Icons.dashboard_rounded;
      case SideNavDestination.mrManagement:
        return Icons.groups_rounded;
      case SideNavDestination.asmManagement:
        return Icons.manage_accounts_rounded;
      case SideNavDestination.teamManagement:
        return Icons.hub_rounded;
      case SideNavDestination.visualAdsManagement:
        return Icons.view_carousel_rounded;
      case SideNavDestination.attendanceRecords:
        return Icons.event_available_rounded;
      case SideNavDestination.dcr:
        return Icons.description_rounded;
      case SideNavDestination.tripPlanManagement:
        return Icons.map_rounded;
      case SideNavDestination.orderManagement:
        return Icons.shopping_bag_rounded;
      case SideNavDestination.distributorManagement:
        return Icons.inventory_2_rounded;
      case SideNavDestination.chemistShopManagement:
        return Icons.store_rounded;
      case SideNavDestination.salarySlipManagement:
        return Icons.receipt_long_rounded;
      case SideNavDestination.notifications:
        return Icons.notifications_rounded;
      case SideNavDestination.profile:
        return Icons.person_rounded;
      case SideNavDestination.aboutUs:
        return Icons.info_rounded;
      case SideNavDestination.helpCenter:
        return Icons.support_agent_rounded;
    }
  }
}

class SideNavBarDrawer extends StatelessWidget {
  const SideNavBarDrawer({
    super.key,
    this.companyName = 'Your Company',
    this.tagline = 'Manage MR, teams, and field ops',
    this.logoAssetPath = 'assets/logo/naiyo24_logo.png',
    this.selected,
    this.onSelected,
    this.width,
  });

  final String companyName;
  final String tagline;
  final String? logoAssetPath;

  final SideNavDestination? selected;
  final ValueChanged<SideNavDestination>? onSelected;

  final double? width;

  static const destinations = <SideNavDestination>[
    SideNavDestination.dashboard,
    SideNavDestination.mrManagement,
    SideNavDestination.asmManagement,
    SideNavDestination.teamManagement,
    SideNavDestination.visualAdsManagement,
    SideNavDestination.attendanceRecords,
    SideNavDestination.dcr,
    SideNavDestination.tripPlanManagement,
    SideNavDestination.orderManagement,
    SideNavDestination.distributorManagement,
    SideNavDestination.chemistShopManagement,
    SideNavDestination.salarySlipManagement,
    SideNavDestination.notifications,
    SideNavDestination.profile,
    SideNavDestination.aboutUs,
    SideNavDestination.helpCenter,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = selected == null
        ? null
        : destinations.indexWhere((d) => d == selected);
    final resolvedSelectedIndex = (selectedIndex == null || selectedIndex < 0)
        ? null
        : selectedIndex;

    return Drawer(
      width: width,
      child: SafeArea(
        child: NavigationDrawer(
          selectedIndex: resolvedSelectedIndex,
          onDestinationSelected: (index) {
            final destination = destinations[index];
            Navigator.of(context).maybePop();
            onSelected?.call(destination);
          },
          children: [
            _SideNavHeader(
              companyName: companyName,
              tagline: tagline,
              logoAssetPath: logoAssetPath,
            ),
            const SizedBox(height: 6),
            for (final d in destinations)
              NavigationDrawerDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.icon),
                label: Text(
                  d.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _SideNavHeader extends StatelessWidget {
  const _SideNavHeader({
    required this.companyName,
    required this.tagline,
    required this.logoAssetPath,
  });

  final String companyName;
  final String tagline;
  final String? logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(76);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _HeaderLogo(logoAssetPath: logoAssetPath),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(166),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo({required this.logoAssetPath});

  final String? logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    Widget child;
    if (logoAssetPath != null && logoAssetPath!.trim().isNotEmpty) {
      child = Image.asset(
        logoAssetPath!,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.local_pharmacy_rounded,
            size: 22,
            color: theme.colorScheme.primary,
          );
        },
      );
    } else {
      child = Icon(
        Icons.local_pharmacy_rounded,
        size: 22,
        color: theme.colorScheme.primary,
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: outline),
      ),
      child: Center(child: child),
    );
  }
}
