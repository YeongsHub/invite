import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  static const _supportEmail = 'support@invite-app.com';

  static const _faqs = [
    (
      q: 'What is the difference between Free and Pro?',
      a: 'Free users can create invitations with basic templates, text, and colors. '
          'Pro users unlock premium fonts, a full color palette, image/camera upload, '
          'and all premium templates.',
    ),
    (
      q: 'How do I upgrade to Pro?',
      a: 'Tap any Pro-locked feature (lock icon) in the app and choose a monthly '
          r'($4.99/month) or yearly ($19.99/year) plan from the upgrade screen.',
    ),
    (
      q: 'How do I cancel my subscription?',
      a: 'Go to Settings → Manage Subscription. '
          'On Android, you will be taken to Google Play subscriptions. '
          'On iOS, you will be taken to your Apple subscription settings.',
    ),
    (
      q: 'Can I restore my purchase on a new device?',
      a: 'Yes. Go to Settings → Restore Purchase. '
          'Make sure you are signed in with the same account used for the original purchase.',
    ),
    (
      q: 'How do I share my invitation?',
      a: 'Tap the download (↓) button in the editor to export your invitation as a PNG image. '
          'You can then share it via any messaging or social app.',
    ),
    (
      q: 'What is RSVP?',
      a: 'RSVP lets guests confirm attendance digitally. '
          'Tap the QR icon in the editor to create an RSVP event. '
          'A QR code is added to your invitation — guests scan it to respond, '
          'and you can view all responses in real time.',
    ),
    (
      q: 'Is my data stored securely?',
      a: 'RSVP responses are stored locally on your device using shared preferences. '
          'No personal data is sent to external servers. '
          'Please refer to our Privacy Policy for full details.',
    ),
    (
      q: 'What languages are supported?',
      a: 'Template content is available in English, Korean, Japanese, Chinese, '
          'French, Spanish, and Arabic. The app UI follows your device language setting.',
    ),
  ];

  Future<void> _sendEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=Invite App Support',
    );
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please email us at $_supportEmail')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ..._faqs.map(
            (faq) => _FaqTile(question: faq.q, answer: faq.a),
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Still need help?',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Contact Support'),
                    onPressed: () => _sendEmail(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      children: [
        Text(
          answer,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
