import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/database/database_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AppDatabase db;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    initDb();
  }

  Future<void> initDb() async {
    db = await DatabaseProvider.database;
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    String name = _nameController.text.trim();
    String password = _passwordController.text;

    // Mặc định gán email là tên + @local (vì trường trong DB cần có email)
    String email = '${name.replaceAll(' ', '_').toLowerCase()}@local.com';
    String phone = '';
    String role = 'user';

    final existingUser = await db.userDao.getUserByEmail(email);
    if (existingUser != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tài khoản đã tồn tại')));
      return;
    }

    User newUser = User(null, name, email, phone, password, role);
    await db.userDao.insertUser(newUser);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Sign Up')),
        backgroundColor: const Color.fromARGB(255, 8, 173, 77),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromARGB(255, 8, 173, 77),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Tên
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Nhập họ tên'
                            : null,
              ),
              const SizedBox(height: 10),

              // Mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nhập mật khẩu';
                  if (value.length < 6) return 'Ít nhất 6 ký tự';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Nút đăng ký
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 8, 173, 77),
                  textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
