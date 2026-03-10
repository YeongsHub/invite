import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms of Service',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Last updated: March 2026',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            SizedBox(height: 24),
            _Section(
              title: '1. Acceptance of Terms',
              body:
                  'By downloading or using Invite, you agree to be bound by these Terms of Service. '
                  'If you do not agree, please do not use the app.',
            ),
            _Section(
              title: '2. Description of Service',
              body:
                  'Invite is a mobile application that allows users to create, design, '
                  'and share digital invitation cards. Some features require a Pro subscription.',
            ),
            _Section(
              title: '3. Subscriptions and Payments',
              body:
                  'Invite offers a free tier and a Pro subscription (monthly or yearly). '
                  'Subscriptions are billed through Google Play or the Apple App Store. '
                  'Prices are displayed in your local currency at the time of purchase. '
                  'Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period.',
            ),
            _Section(
              title: '4. Cancellation and Refunds',
              body:
                  'You may cancel your subscription at any time through your store account settings. '
                  'Cancellation takes effect at the end of the current billing period. '
                  'Refunds are handled according to Google Play or Apple App Store policies.',
            ),
            _Section(
              title: '5. User Content',
              body:
                  'You retain ownership of any content you create using Invite. '
                  'You are solely responsible for the content of your invitations. '
                  'You agree not to create invitations that are unlawful, harmful, or offensive.',
            ),
            _Section(
              title: '6. Intellectual Property',
              body:
                  'The Invite app, including its design, templates, and code, is owned by the developer. '
                  'You may not copy, modify, or distribute the app or its components without permission.',
            ),
            _Section(
              title: '7. Disclaimer of Warranties',
              body:
                  'Invite is provided "as is" without warranties of any kind. '
                  'We do not guarantee uninterrupted or error-free service.',
            ),
            _Section(
              title: '8. Limitation of Liability',
              body:
                  'To the maximum extent permitted by law, the developer shall not be liable '
                  'for any indirect, incidental, or consequential damages arising from your use of Invite.',
            ),
            _Section(
              title: '9. Changes to Terms',
              body:
                  'We may update these Terms at any time. Continued use of the app after changes '
                  'constitutes acceptance of the new Terms.',
            ),
            _Section(
              title: '10. Contact',
              body:
                  'For questions about these Terms, please contact:\nsupport@invite-app.com',
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
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(body,
              style: const TextStyle(
                  fontSize: 13, height: 1.6, color: Colors.black87)),
        ],
      ),
    );
  }
}
