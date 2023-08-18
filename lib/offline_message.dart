import 'package:flutter/material.dart';
import 'package:android_intent/android_intent.dart';

class OfflineMessagePage extends StatelessWidget {
  const OfflineMessagePage({super.key});

  Future<void> _callEmergencyService(BuildContext context,
      String phoneNumber) async {
    final intent = AndroidIntent(
      action: 'android.intent.action.DIAL',
      data: 'tel:$phoneNumber',
    );
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await intent.launch();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Could not initiate call'),
        ),
      );
    }
  }

  Widget _buildEmergencyButton(BuildContext context, String text,
      String number) {
    return ElevatedButton(
      onPressed: () async {
        await _callEmergencyService(context, number);
      },
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Message'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Back to Home'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
          _buildEmergencyButton(context, 'Call Police (100)', '100'),
          const SizedBox(height: 16),
          _buildEmergencyButton(context, 'Call Ambulance (102)', '102'),
          const SizedBox(height: 16),
          _buildEmergencyButton(context, 'Call Fire Brigade (101)', '101'),
          const SizedBox(height: 16),
          _buildEmergencyButton(context, 'Call Women Helpline (1091)', '1091'),
          const SizedBox(height: 16),
          _buildEmergencyButton(context, 'Call Child Helpline (1098)', '1098'),
        ],
      ),
    );
  }
}