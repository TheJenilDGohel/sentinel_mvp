import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../sos/presentation/providers/sos_provider.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationNotifierProvider);
    final sosState = ref.watch(sosNotifierProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 28),
            _buildSosButton(context, ref, sosState),
            const SizedBox(height: 24),
            _buildLocationCard(context, ref, locationState),
            const SizedBox(height: 16),
            Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildQuickActions(context, ref),
            const SizedBox(height: 20),
            _buildRecentSos(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.shield_rounded, color: AppTheme.primaryColor, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sentinel', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              Text('Your safety companion', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.successColor, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('Active', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.successColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSosButton(BuildContext context, WidgetRef ref, SosState sosState) {
    final isLoading = sosState.status == SosTriggerStatus.loading;
    return Center(
      child: GestureDetector(
        onTap: isLoading ? null : () => _showSosConfirmation(context, ref),
        child: Container(
          width: 180, height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFFF4444), Color(0xFFC62828)],
              center: Alignment(-0.2, -0.2), radius: 0.8,
            ),
            boxShadow: [
              BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 5),
              BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 60, spreadRadius: 15),
            ],
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sos_rounded, size: 48, color: Colors.white),
                      const SizedBox(height: 4),
                      Text('SOS', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 3)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, WidgetRef ref, LocationState locationState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.secondaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.location_on_rounded, color: AppTheme.secondaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Current Location', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              if (locationState.isLoading)
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              else
                IconButton(icon: const Icon(Icons.refresh_rounded, size: 20), onPressed: () => ref.read(locationNotifierProvider.notifier).fetchCurrentLocation(), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          ),
          const SizedBox(height: 12),
          if (locationState.error != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Icon(Icons.error_outline, color: Colors.red.shade400, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(locationState.error!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red.shade700))),
              ]),
            )
          else if (locationState.position != null)
            Row(children: [
              Expanded(child: _coordChip(context, 'Lat', locationState.position!.latitude.toStringAsFixed(6))),
              const SizedBox(width: 8),
              Expanded(child: _coordChip(context, 'Lng', locationState.position!.longitude.toStringAsFixed(6))),
            ])
          else
            Text('Tap refresh to get location', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _coordChip(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Text('$label: ', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade500)),
        Expanded(child: Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontFamily: 'monospace'), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(child: _actionCard(context, Icons.report_rounded, 'Report\nIncident', AppTheme.accentColor, () => context.go('/report'))),
        const SizedBox(width: 12),
        Expanded(child: _actionCard(context, Icons.my_location_rounded, 'Refresh\nLocation', AppTheme.successColor, () => ref.read(locationNotifierProvider.notifier).fetchCurrentLocation())),
      ],
    );
  }

  Widget _actionCard(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
        ]),
      ),
    );
  }

  Widget _buildRecentSos(BuildContext context, WidgetRef ref) {
    final sosHistory = ref.watch(sosHistoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent SOS Events', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        sosHistory.when(
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
          error: (error, stack) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const Text('Failed to load SOS history')),
          data: (events) {
            if (events.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Center(child: Column(children: [
                  Icon(Icons.verified_user_rounded, size: 40, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text('No SOS events yet', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500)),
                ])),
              );
            }
            return Column(children: events.take(5).map((e) => _sosEventTile(context, e)).toList());
          },
        ),
      ],
    );
  }

  Widget _sosEventTile(BuildContext context, dynamic event) {
    final hasLoc = event.latitude != null && event.longitude != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.sos_rounded, color: AppTheme.primaryColor, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('SOS Alert', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          Text('${event.timestamp}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500)),
        ])),
        Icon(hasLoc ? Icons.location_on_rounded : Icons.location_off_rounded, size: 18, color: hasLoc ? AppTheme.successColor : Colors.grey.shade400),
      ]),
    );
  }

  void _showSosConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.warning_amber_rounded, size: 48, color: AppTheme.primaryColor),
        title: const Text('Trigger SOS Alert?'),
        content: const Text('This will record an emergency SOS event with your current location and timestamp.', textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600))),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            onPressed: () {
              Navigator.pop(ctx);
              _triggerSos(context, ref);
            },
            child: const Text('Confirm SOS'),
          ),
        ],
      ),
    );
  }

  Future<void> _triggerSos(BuildContext context, WidgetRef ref) async {
    final event = await ref.read(sosNotifierProvider.notifier).triggerSos();
    if (context.mounted) {
      if (event != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🚨 SOS Alert Triggered!'), backgroundColor: AppTheme.primaryColor));
      } else {
        final msg = ref.read(sosNotifierProvider).errorMessage ?? 'Failed';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
      }
      ref.read(sosNotifierProvider.notifier).resetState();
    }
  }
}
