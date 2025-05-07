import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onRegisterPressed;

  const LoginPage({super.key, this.onRegisterPressed});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  Future<void> _submit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      if (_isLogin) {
        await authProvider.signIn(
          _emailController.text,
          _passwordController.text,
        );

        // Rediriger vers la page d’accueil après connexion réussie
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/overview');
      } else {
        await authProvider.signUp(
          _emailController.text,
          _passwordController.text,
        );

        setState(() {
          _isLogin = true;
        });

        if (!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Inscription réussie ! Veuillez vous connecter.'),
  ),
);

        

        // Appeler saveData() ou autre logique si fourni
        if (widget.onRegisterPressed != null) {
          widget.onRegisterPressed!();
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Connexion' : 'Inscription'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.pushNamed(context, '/debug');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? 'Se connecter' : 'S\'inscrire'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin
                  ? 'Pas de compte ? Inscrivez-vous'
                  : 'Déjà un compte ? Connectez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}
