import 'package:flutter/material.dart';

class UnsupportedDevicePlaceholder extends StatelessWidget {
  const UnsupportedDevicePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 186, 195, 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.info_outline,
                size: 48,
                color: Color.fromRGBO(0, 186, 195, 1),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            const Text(
              'Knowledge Cards',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Description
            const Text(
              'Smart extracts of key ideas, terms, and insights from your content.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Requirements section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.devices_rounded,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Supported Devices:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // iPhone models
                  _buildDeviceItem(
                    icon: Icons.phone_iphone,
                    title: 'iPhone',
                    devices: [
                      'iPhone 15 Pro / Pro Max (A17 Pro)',
                      'iPhone 16 / Plus / Pro / Pro Max (A18)',
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // iPad models
                  _buildDeviceItem(
                    icon: Icons.tablet_mac,
                    title: 'iPad',
                    devices: [
                      'iPad with M1 chip or newer',
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Mac models
                  _buildDeviceItem(
                    icon: Icons.laptop_mac,
                    title: 'Mac',
                    devices: [
                      'Mac с Apple Silicon (M1/M2/M3/M4)',
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // OS requirement
                  Row(
                    children: [
                      Icon(
                        Icons.system_update,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child:                         Text(
                          'Minimum Requirements: iOS 18.1+',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Future update message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 186, 195, 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.update,
                    color: Color.fromRGBO(0, 186, 195, 1),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This feature will be available for other devices in the next version',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // No action needed - user can just switch tabs
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 186, 195, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDeviceItem({
    required IconData icon,
    required String title,
    required List<String> devices,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color.fromRGBO(0, 186, 195, 1),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...devices.map((device) => Padding(
          padding: const EdgeInsets.only(left: 26, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Expanded(
                child: Text(
                  device,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
