import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:brana/core/theme/app_colors.dart';
import 'package:brana/features/auth/view/Pages/sign_up.dart';
import 'package:brana/features/auth/view/Widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:brana/features/pdf_reader/view/pdf_reader_page.dart';

final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  bool _isSigningIn = false;

  // Example image asset paths (replace with your own assets)
  final List<String> imageList = [
    'assets/images/user1.png',
    'assets/images/user2.png',
    'assets/images/user3.png',
    'assets/images/user4.png',
    'assets/images/user5.png',
  ];

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PdfReaderPage(),
          ),
        );
      }
    });
  }

  Future<void> _googleSignIn() async {
    if (_isSigningIn) return;
    setState(() => _isSigningIn = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']!,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final accessToken = googleAuth?.accessToken;
      final idToken = googleAuth?.idToken;

      if (accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Access Token found.')),
        );
        debugPrint('Google sign-in failed: No Access Token found.');
        return;
      }
      if (idToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No ID Token found.')),
        );
        debugPrint('Google sign-in failed: No ID Token found.');
        return;
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e, stack) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in error: $e')),
      );
      debugPrint('Google sign-in error: $e');
      debugPrint('Stack trace: $stack');
    } finally {
      setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                'Welcome to Brana',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AuthTextField(
                hintText: 'Email address',
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                hintText: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (val) {
                      setState(() => rememberMe = val ?? false);
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Text('Remember me',
                      style: TextStyle(color: Colors.white)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              AuthPrimaryButton(
                text: 'Log in',
                onPressed: () {
                  // TODO: Implement email/password login if you want
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: Image.asset(
                  'assets/icons/google.png', // Make sure this asset exists!
                  height: 24,
                  width: 24,
                ),
                label: const Text('Sign in with Google'),
                onPressed: _googleSignIn,
              ),
              const SizedBox(height: 16),
              // Image row
              // SizedBox(
              //   height: 72,
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: imageList.length,
              //     separatorBuilder: (context, index) =>
              //         const SizedBox(width: 12),
              //     itemBuilder: (context, index) {
              //       return ClipRRect(
              //         borderRadius: BorderRadius.circular(16),
              //         child: Image.asset(
              //           imageList[index],
              //           width: 56,
              //           height: 56,
              //           fit: BoxFit.cover,
              //         ),
              //       );
              //     },
              //   ),
              // ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'New to Brana? ',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
