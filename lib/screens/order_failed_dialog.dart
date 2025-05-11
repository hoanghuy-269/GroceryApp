import 'package:flutter/material.dart';

class OrderFailedDialog extends StatelessWidget {
  const OrderFailedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: const Icon(Icons.close, size: 24),
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/grocery_bag.png', // Đảm bảo ảnh đã thêm trong pubspec.yaml
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops! Order Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Something went temply wrong',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Retry action
                  Navigator.of(context).maybePop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Please Try Again',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).maybePop();
              },
              child: const Text(
                'Back To Home',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
