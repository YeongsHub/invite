import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invite/core/di/rsvp_provider.dart';
import 'package:invite/core/theme/app_colors.dart';
import 'package:invite/shared/models/rsvp_models.dart';

class RsvpListPage extends ConsumerStatefulWidget {
  const RsvpListPage({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<RsvpListPage> createState() => _RsvpListPageState();
}

class _RsvpListPageState extends ConsumerState<RsvpListPage> {
  /// Formats a [DateTime] as "Mar 10 · 2:30 PM".
  String _formatTimestamp(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final month = months[dt.month - 1];
    final day = dt.day;
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$month $day · $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final rsvpAsync = ref.watch(rsvpProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Responses'),
        leading: const BackButton(),
      ),
      body: rsvpAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'Something went wrong.\n$err',
            textAlign: TextAlign.center,
          ),
        ),
        data: (state) {
          final responses = state.responses
              .where((r) => r.eventId == widget.eventId)
              .toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          final attending = responses.where((r) => r.attending).length;
          final declining = responses.where((r) => !r.attending).length;
          final total = responses.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Summary cards row ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: 'Attending',
                        count: attending,
                        color: const Color(0xFF2E7D32), // green-800
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryCard(
                        label: 'Declining',
                        count: declining,
                        color: const Color(0xFFC62828), // red-800
                        icon: Icons.cancel_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryCard(
                        label: 'Total',
                        count: total,
                        color: AppColors.primary,
                        icon: Icons.people_outline,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Section divider ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Responses',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              color: AppColors.onSurface.withValues(alpha: 0.5),
                            ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),

              // ── Response list or empty state ───────────────────────────
              Expanded(
                child: responses.isEmpty
                    ? _EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: responses.length,
                        itemBuilder: (context, index) => _ResponseCard(
                          response: responses[index],
                          formattedTime: _formatTimestamp(responses[index].timestamp),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary card widget
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  final String label;
  final int count;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.85),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Response card widget
// ─────────────────────────────────────────────────────────────────────────────

class _ResponseCard extends StatelessWidget {
  const _ResponseCard({
    required this.response,
    required this.formattedTime,
  });

  final RsvpResponse response;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    final borderColor = response.attending
        ? const Color(0xFF388E3C) // green-700
        : const Color(0xFFD32F2F); // red-700

    final statusIcon = response.attending
        ? Icons.check_circle
        : Icons.cancel;
    final statusColor = response.attending
        ? const Color(0xFF388E3C)
        : const Color(0xFFD32F2F);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Coloured left border
            Container(width: 4, color: borderColor),

            // Card body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name row
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            response.guestName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(statusIcon, size: 18, color: statusColor),
                      ],
                    ),

                    // Optional message
                    if (response.message.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 14,
                            color: AppColors.onSurface.withValues(alpha: 0.45),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              response.message,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.onSurface.withValues(alpha: 0.7),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Timestamp
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 13,
                          color: AppColors.onSurface.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurface.withValues(alpha: 0.45),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state widget
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code,
              size: 96,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No responses yet.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface.withValues(alpha: 0.75),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Share your QR code!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.45),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
