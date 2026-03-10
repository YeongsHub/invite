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
    return Scaffold(
      appBar: AppBar(title: const Text('RSVP')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 24),

              // Attending toggle
              const Text(
                'Will you attend?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
