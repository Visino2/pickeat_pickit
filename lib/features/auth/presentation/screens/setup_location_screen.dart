
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SetupLocationScreen extends StatelessWidget {
  const SetupLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Delivery Location')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 64, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              'Find restaurants near you',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
             const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                // Implement location fetching logic
                context.go('/home');
              },
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // Implement map picker
                context.go('/home');
              },
               icon: const Icon(Icons.map),
              label: const Text('Choose from Map'),
               style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
