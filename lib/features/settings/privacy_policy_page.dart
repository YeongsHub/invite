import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Last updated: March 2026', style: TextStyle(color: Colors.grey, fontSize: 13)),
            SizedBox(height: 24),
            _Section(
              title: '1. Information We Collect',
              body:
                  'Invite does not collect or transmit any personal information to external servers. '
                  'All invitation data and RSVP responses are stored locally on your device.',
            ),
            _Section(
              title: '2. Advertising',
              body:
                  'We use Google AdMob to display advertisements to free-tier users. '
                  'AdMob may collect device identifiers and usage data to serve personalized ads. '
                  'On iOS, we request App Tracking Transparency (ATT) permission before enabling personalized ads. '
                  'You can opt out at any time through your device settings.',
            ),
            _Section(
              title: '3. In-App Purchases',
              body:
                  'Subscription purchases (Pro Monthly, Pro Yearly) are processed securely '
                  'through Google Play or Apple App Store. '
                  'We do not receive or store your payment information.',
            ),
            _Section(
              title: '4. Camera and Photo Library',
              body:
                  'Pro users may grant access to the camera and photo library to add images '
                  'to invitation cards. Photos are used only within the app and are not uploaded '
                  'or shared externally.',
            ),
            _Section(
              title: '5. RSVP Data',
              body:
                  'RSVP event data and guest responses are stored locally on your device '
                  'using shared preferences. This data is not sent to any server.',
            ),
            _Section(
              title: '6. Third-Party Services',
              body:
                  '• Google AdMob — advertising\n'
                  '• Google Play / Apple App Store — payment processing\n'
                  '• Google Fonts — font rendering (downloaded at runtime)\n\n'
                  'Each service has its own privacy policy.',
            ),
            _Section(
              title: '7. Children\'s Privacy',
              body:
                  'Invite is not directed at children under 13. '
                  'We do not knowingly collect personal data from children.',
            ),
            _Section(
              title: '8. Contact Us',
              body: 'If you have questions about this Privacy Policy, please contact:\nsupport@invite-app.com',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(body,
              style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black87)),
        ],
      ),
    );
  }
}
