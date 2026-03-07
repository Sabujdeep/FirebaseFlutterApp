import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_01/screens/homepage.dart';
import 'package:flutter_app_01/screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String? verificationId;
  bool otpSent = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // ---------------- GOOGLE LOGIN ----------------

  Future<UserCredential?> signInWithGoogle() async {

    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential);
  }

  // ---------------- EMAIL LOGIN ----------------

  Future<void> loginUser() async {

    if (_formKey.currentState!.validate()) {

      try {

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );

      } on FirebaseAuthException catch (e) {

        if (e.code == 'user-not-found') {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("No user found with this email")),
          );

        } else if (e.code == 'wrong-password') {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Wrong password")),
          );

        } else {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Login failed")),
          );
        }

      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong")),
        );
      }
    }
  }

  // ---------------- SEND OTP ----------------

  Future<void> sendOTP() async {

    await FirebaseAuth.instance.verifyPhoneNumber(

      phoneNumber: phoneController.text.trim(),

      verificationCompleted:
          (PhoneAuthCredential credential) async {

        await FirebaseAuth.instance
            .signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "OTP Failed")),
        );
      },

      codeSent: (String verId, int? resendToken) {

        setState(() {
          verificationId = verId;
          otpSent = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Sent")),
        );
      },

      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  // ---------------- VERIFY OTP ----------------

  Future<void> verifyOTP() async {

    try {

      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,
            autovalidateMode:
                AutovalidateMode.onUserInteraction,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 30),

                // EMAIL

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PASSWORD

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {

                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    }

                    if (value.length < 6) {
                      return "Password must be 6 characters";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: loginUser,
                  child: const Text("Login"),
                ),

                const SizedBox(height: 20),

                // GOOGLE LOGIN

                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label:
                      const Text("Continue with Google"),
                  onPressed: () async {

                    try {

                      await signInWithGoogle();

                      if (!mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const HomeScreen(),
                        ),
                      );

                    } catch (e) {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                            content:
                                Text("Google Login Failed")),
                      );
                    }
                  },
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 20),

                // PHONE NUMBER

                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText:
                        "Phone Number (+91XXXXXXXXXX)",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: sendOTP,
                  child: const Text("Send OTP"),
                ),

                const SizedBox(height: 20),

                if (otpSent) ...[

                  TextFormField(
                    controller: otpController,
                    decoration: const InputDecoration(
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: verifyOTP,
                    child: const Text("Verify OTP"),
                  ),
                ],

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    const Text("Don't have an account?"),

                    TextButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SignupPage(),
                          ),
                        );
                      },
                      child: const Text("Sign Up"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}