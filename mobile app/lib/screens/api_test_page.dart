import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

/// Test page to verify Flask API integration
/// Access via: Navigator.push(context, MaterialPageRoute(builder: (_) => ApiTestPage()))
class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  bool _isLoading = false;
  String _result = '';
  bool _isConnected = false;
  bool _testingConnection = false;

  // Sample test data (mock CBC values)
  final List<double> _sampleFeatures = [
    12.5, // HGB
    4.2,  // RBC
    7000, // WBC
    250,  // PLT
    30.0, // LYMP
    5.0,  // MONO
    37.5, // HCT
    85.0, // MCV
    30.0, // MCH
    33.0, // MCHC
    14.0, // RDW
    10.0, // PDW
    9.0,  // MPV
    0.25, // PCT
    60.0, // NEU
    2.0,  // EOS
  ];

  Future<void> _testConnection() async {
    setState(() {
      _testingConnection = true;
      _result = 'Testing connection...';
    });

    try {
      final connected = await ApiService.testConnection();
      setState(() {
        _isConnected = connected;
        _result = connected
            ? '✅ Backend is ONLINE and reachable!\nURL: http://192.168.1.53:5000'
            : '❌ Backend is OFFLINE or unreachable.\nPlease check:\n• Backend is running\n• Both devices on same WiFi\n• IP address is correct';
        _testingConnection = false;
      });
    } catch (e) {
      setState(() {
        _result = '❌ Connection test failed: $e';
        _isConnected = false;
        _testingConnection = false;
      });
    }
  }

  Future<void> _testPrediction() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing requires an actual image file.\nPlease use the Upload screen to test the API.';
      _isLoading = false;
    });
  }

  Future<void> _testInvalidData() async {
    setState(() {
      _isLoading = true;
      _result = '''
ℹ️ API Test Info

The new API endpoint is:
POST /predict_from_image

It accepts image files via multipart/form-data.

To test:
1. Go to Upload screen
2. Select a CBC report image
3. Click "Analyze Report"
4. Backend will extract CBC values
5. Results will show on next screen

No manual testing needed here.
''';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'API Integration Test',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Colors.purple.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.api_rounded,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Flask Backend Test Suite',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'http://127.0.0.1:5000/predict_from_image',
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Connection Status
            if (_isConnected)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Text(
                      'Backend Connected',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Test Buttons
            _buildTestButton(
              icon: Icons.wifi_rounded,
              label: 'Test Connection',
              onPressed: _testConnection,
              isLoading: _testingConnection,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildTestButton(
              icon: Icons.info_rounded,
              label: 'API Info',
              onPressed: _testPrediction,
              isLoading: _isLoading,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildTestButton(
              icon: Icons.upload_rounded,
              label: 'How to Test',
              onPressed: _testInvalidData,
              isLoading: _isLoading,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),

            // Results
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.terminal_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Results',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _result,
                        style: GoogleFonts.robotoMono(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isLoading,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
