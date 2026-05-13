import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../incidents/presentation/providers/incident_provider.dart';

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidents = ref.watch(incidentHistoryProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Text('Incident History', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            ),
          ),
          incidents.when(
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (error, stack) => const SliverFillRemaining(child: Center(child: Text('Failed to load history'))),
            data: (reports) {
              if (reports.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.inbox_rounded, size: 56, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text('No incidents reported', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500)),
                  ])),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final r = reports[index];
                    final dateStr = DateFormat('MMM dd, yyyy • hh:mm a').format(r.timestamp);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))]),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(r.incidentType, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.accentColor, fontWeight: FontWeight.w600))),
                          const Spacer(),
                          Text(dateStr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500)),
                        ]),
                        const SizedBox(height: 8),
                        Text(r.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                        if (r.latitude != null) ...[
                          const SizedBox(height: 6),
                          Row(children: [
                            const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.secondaryColor),
                            const SizedBox(width: 4),
                            Text('${r.latitude!.toStringAsFixed(4)}, ${r.longitude!.toStringAsFixed(4)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500, fontFamily: 'monospace', fontSize: 11)),
                          ]),
                        ],
                      ]),
                    );
                  }, childCount: reports.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
