import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'emergency_services.dart';

class EmergencyService {
  final String name;
  final String phoneNumber;

  const EmergencyService({required this.name, required this.phoneNumber});
}

class HomePage extends StatelessWidget {
  static const emergencyServices = [
    EmergencyService(name: 'Police', phoneNumber: '100'),
    EmergencyService(name: 'Fire', phoneNumber: '101'),
    EmergencyService(name: 'Ambulance', phoneNumber: '108'),
    EmergencyService(name: 'Women Helpline', phoneNumber: '1091'),
    EmergencyService(name: 'Child Helpline', phoneNumber: '1098'),
  ];

  const HomePage({super.key});

  Future<void> _callEmergencyService(BuildContext context, String phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not initiate call'),
        ),
      );
    }
  }

  Widget _buildEmergencyButton(BuildContext context, String text, String number) {
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
      appBar: AppBar(title: const Text('Emergency Services')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Emergency Response'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmergencyServicesPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final service in emergencyServices)
              _buildEmergencyButton(context, service.name, service.phoneNumber),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
