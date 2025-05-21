import 'package:flutter/material.dart';
import 'package:grocery_app/screens/botttom_navgation_srceen.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_app/database/database_provider.dart';
import 'package:grocery_app/screens/admin_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  bool _adminCreated = false;

  @override
  void initState() {
    super.initState();
    _checkAdminExists();
  }

  Future<void> _checkAdminExists() async {
    final db =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    User? existingAdmin = await db.userDao.getUserByEmail('admin@example.com');
    if (existingAdmin != null) {
      setState(() {
        _adminCreated = true;
      });
    }
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  Future<void> _createAdminAccount() async {
    if (_adminCreated) return;

    setState(() {
      _isLoading = true;
    });

    final db =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    User? existingAdmin = await db.userDao.getUserByEmail('admin@example.com');
    if (existingAdmin != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin account already exists')),
      );
      setState(() {
        _isLoading = false;
        _adminCreated = true;
      });
      return;
    }

    User adminUser = User(
      null,
      "",
      'admin@example.com',
      "",
      'admin123',
      'admin',
    );

    await db.userDao.insertUser(adminUser);

    setState(() {
      _isLoading = false;
      _adminCreated = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Admin account created successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 223, 122),
      appBar: AppBar(
        title: const Center(child: Text('Login')),
        backgroundColor: const Color.fromARGB(255, 40, 223, 122),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/avata.jpg"),
              ),
              const SizedBox(height: 30),

              // Tên đăng nhập
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Mật khẩu
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
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
            const SizedBox(height: 20),
            if (!_adminCreated)
              ElevatedButton(
                onPressed: _isLoading ? null : _loginWithName,
                onPressed: _isLoading ? null : _createAdminAccount,
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Admin Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  Future<void> _loginWithName() async {
    String name = _nameController.text.trim();
    String password = _passwordController.text.trim();
  Future<void> _user() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final db = await DatabaseProvider.database;
    final user = await db.userDao.getUserByName(name); // ⚠️ cần hàm này

    AppDatabase db =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    User? user = await db.userDao.getUserByEmail(email);

    setState(() {
      _isLoading = false;
    });

    if (user != null && user.password == password) {
      await saveUserName(user.name);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyBottom(userName: user.name)),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid name or password')));

    if (user != null && password == user.password) {
      await saveUserEmail(user.email);

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
