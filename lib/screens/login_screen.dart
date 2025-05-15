import 'package:flutter/material.dart';
import 'package:grocery_app/screens/botttom_navgation_srceen.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/screens/sign_up_screen.dart';
import 'package:grocery_app/screens/admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Hàm tạo tài khoản admin
  _createAdminAccount() async {
    const adminEmail = 'admin@gmail.com';
    const adminPassword = 'admin123';

    setState(() {
      _isLoading = true;
    });

    AppDatabase db =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    // Kiểm tra xem admin đã tồn tại chưa
    User? existingAdmin = await db.userDao.getUserByEmail(adminEmail);

    if (existingAdmin == null) {
      final adminUser = User(
        null,
        "",
        adminEmail,
        "",
        adminPassword,
        'admin',

        // Thêm các trường khác nếu cần
      ); // Thêm các trường khác nếu cần

      await db.userDao.insertUser(adminUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin account created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin account already exists!')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),
        backgroundColor: const Color.fromARGB(255, 40, 223, 122),
        // Bỏ actions nếu không cần
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 40, 223, 122),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/avata.jpg"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _user,
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Create a new account'),
            ),

            // Nút tạo admin luôn hiển thị
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _createAdminAccount,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Admin Account'),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm kiểm tra đăng nhập (giữ nguyên)
  _user() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    AppDatabase db =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    User? user = await db.userDao.getUserByEmail(email);

    setState(() {
      _isLoading = false;
    });

    if (user != null && password == user.password) {
      if (user.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyBottom(userEmail: user.email),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }
}
