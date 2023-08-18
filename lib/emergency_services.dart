import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';


const kCardIconSize = 48.0;

class EmergencyService {
  final String serviceType;
  final String serviceContactNumber;

  EmergencyService({required this.serviceType, required this.serviceContactNumber});
}

class EmergencyServicesPage extends StatefulWidget {
  const EmergencyServicesPage({Key? key}) : super(key: key);

  @override
  _EmergencyServicesPageState createState() => _EmergencyServicesPageState();
}

class _EmergencyServicesPageState extends State<EmergencyServicesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _disasters = const [
    'Cyclone',
    'Tsunami',
    'Heat Wave',
    'Landslide',
    'Floods',
    'Earthquakes',
  ];

  final Map<String, String> _disasterInformation = const {
    'Cyclone': 'https://www.ndma.gov.in/Natural-Hazards/Cyclone',
    'Tsunami': 'https://www.ndma.gov.in/Natural-Hazards/Tsunami',
    'Heat Wave': 'https://www.ndma.gov.in/Natural-Hazards/Heat-Wave',
    'Landslide': 'https://www.ndma.gov.in/Natural-Hazards/Landslide',
    'Floods': 'https://www.ndma.gov.in/Natural-Hazards/Floods',
    'Earthquakes': 'https://www.ndma.gov.in/Natural-Hazards/Earthquakes',
  };

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildDisasterCard(String disaster, String url) {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) {
                  if (request.url == url) {
                    return NavigationDecision.navigate;
                  } else {
                    return NavigationDecision.prevent;
                  }
                },
              ),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  size: kCardIconSize,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        disaster,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'View Guidelines',
                        style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Guidelines for Natural Disasters:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ..._disasters.map(
                  (disaster) => _buildDisasterCard(
                disaster,
                _disasterInformation[disaster]!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
