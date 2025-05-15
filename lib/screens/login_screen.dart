import 'package:flutter/material.dart';
import 'package:grocery_app/screens/botttom_navgation_srceen.dart'; // Import MyBottom screen
import 'package:grocery_app/database/app_database.dart'; // Import database
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/screens/sign_up_screen.dart'; // Import SignUp screen
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true; // Trạng thái hiển thị mật khẩu

  // Hàm kiểm tra đăng nhập
  _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Kiểm tra email và mật khẩu
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Lấy thông tin người dùng từ cơ sở dữ liệu
    AppDatabase db =
         await $FloorAppDatabase.databaseBuilder('app_database.db').build();
         User? user = await db.userDao.getUserByEmail(email);

    setState(() {
      _isLoading = false;
    });

    // Kiểm tra thông tin người dùng và mật khẩu
    if (user != null && password == user.password) {
      // Đăng nhập thành công, chuyển sang MyBottom và truyền email
        await saveUserEmail(user.email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => MyBottom(
                userEmail: user.email,
              ), // Truyền email người dùng vào MyBottom
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  // hàm thống lưu email 
  Future<void> saveUserEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_email', email);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Login')),
        backgroundColor: const Color.fromARGB(255, 40, 223, 122),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 40, 223, 122),
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
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent, // Thay đổi màu chữ tại đây
              ),
              child: const Text('Create a new account'),
            ),
          ],
        ),
      ),
    );
  }
}
