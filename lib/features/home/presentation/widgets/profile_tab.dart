import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 44,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: const Icon(Icons.person_rounded, size: 44, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              user?.email?.replaceAll('@sentinel.app', '') ?? 'User',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text('Sentinel User', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500)),
            const SizedBox(height: 40),
            ListTile(
              leading: const Icon(Icons.shield_rounded, color: AppTheme.darkSurface),
              title: const Text('About Sentinel'),
              trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_rounded, color: AppTheme.darkSurface),
              title: const Text('Privacy Policy'),
              trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 52,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout_rounded, color: AppTheme.primaryColor),
                label: const Text('Sign Out', style: TextStyle(color: AppTheme.primaryColor)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Sentinel MVP v1.0', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}
