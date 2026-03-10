import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:invite/core/di/providers.dart';
import 'package:invite/shared/models/rsvp_models.dart';

class RsvpResponsePage extends ConsumerStatefulWidget {
  const RsvpResponsePage({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<RsvpResponsePage> createState() => _RsvpResponsePageState();
}

class _RsvpResponsePageState extends ConsumerState<RsvpResponsePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  bool _attending = true;
  bool _submitting = false;
  int _guestCount = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);

    final response = RsvpResponse(
      id: const Uuid().v4(),
      eventId: widget.eventId,
      guestName: _nameController.text.trim(),
      attending: _attending,
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
      guestCount: _attending ? _guestCount : 0,
    );

    await ref.read(rsvpProvider.notifier).addResponse(response);

    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final rsvpAsync = ref.watch(rsvpProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('RSVP')),
      body: rsvpAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) {
          final event = state.events
              .where((e) => e.id == widget.eventId)
              .firstOrNull;

          if (event != null && event.isExpired) {
            return _DeadlineExpiredView(event: event);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (event != null && event.deadline != null)
                    _DeadlineBanner(deadline: event.deadline!),

                  // Event ID info
                  Text(
                    'Event: ${widget.eventId}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black45,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),

                  // Guest name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Please enter your name'
                            : null,
                  ),
                  const SizedBox(height: 24),

                  // Attending toggle
                  const Text(
                    'Will you attend?',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _AttendToggleButton(
                          label: '✓  Attending',
                          selected: _attending,
                          selectedColor: const Color(0xFF2E7D32),
                          onTap: () => setState(() => _attending = true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AttendToggleButton(
                          label: '✗  Declining',
                          selected: !_attending,
                          selectedColor: const Color(0xFFC62828),
                          onTap: () => setState(() => _attending = false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Guest count (only when attending)
                  if (_attending) ...[
                    const Text(
                      'Number of guests',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    _GuestCountStepper(
                      count: _guestCount,
                      onChanged: (v) => setState(() => _guestCount = v),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Optional message
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message (optional)',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // Submit
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Submit RSVP'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DeadlineBanner extends StatelessWidget {
  const _DeadlineBanner({required this.deadline});
  final DateTime deadline;

  @override
  Widget build(BuildContext context) {
    final daysLeft = deadline.difference(DateTime.now()).inDays;
    final label = daysLeft == 0
        ? 'RSVP closes today!'
        : 'RSVP by ${deadline.year}/${deadline.month.toString().padLeft(2, '0')}/${deadline.day.toString().padLeft(2, '0')} ($daysLeft day${daysLeft == 1 ? '' : 's'} left)';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFB74D), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 16, color: Color(0xFFE65100)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFE65100),
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _DeadlineExpiredView extends StatelessWidget {
  const _DeadlineExpiredView({required this.event});
  final RsvpEvent event;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 72, color: Colors.black26),
            const SizedBox(height: 24),
            Text(
              'RSVP Closed',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'The RSVP deadline for "${event.title}" has passed.',
              style: const TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestCountStepper extends StatelessWidget {
  const _GuestCountStepper({required this.count, required this.onChanged});
  final int count;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepButton(
          icon: Icons.remove,
          onTap: count > 1 ? () => onChanged(count - 1) : null,
        ),
        const SizedBox(width: 16),
        Text(
          '$count',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 16),
        _StepButton(
          icon: Icons.add,
          onTap: count < 20 ? () => onChanged(count + 1) : null,
        ),
        const SizedBox(width: 12),
        Text(
          count == 1 ? 'person' : 'people',
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null ? Colors.black87 : Colors.grey.shade300,
        ),
        child: Icon(icon,
            size: 18,
            color: onTap != null ? Colors.white : Colors.grey.shade500),
      ),
    );
  }
}

class _AttendToggleButton extends StatelessWidget {
  const _AttendToggleButton({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? selectedColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: selected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}
