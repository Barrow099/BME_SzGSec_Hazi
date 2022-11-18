import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider_objects.dart';
import 'landing_page_background.dart';
import 'signup_page.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LandingPagesBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(
              flex: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      child: const AutoSizeText(
                        "Caff Shop",
                        style: TextStyle(
                            fontSize: 300,
                            shadows: [Shadow(color: Color.fromARGB(100, 45, 78, 128), blurRadius: 90)],
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                        ),
                        maxLines: 1,
                      )),
                ],
              ),
            ),
            const Spacer(
              flex: 24,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: ElevatedButton(
                  onPressed: goToLoginPage,
                  child: const Text("Login"),
                )),
            // Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            //     child: ElevatedButton(
            //       onPressed: goToSignupPage,
            //       child: const Text("Sign up"),
            //     )),
            const Spacer(
              flex: 5,
            )
          ],
        ),
      ),
    );
  }

  goToLoginPage() async {
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => const LoginPage())
    // );
    ref.read(authStateNotifier.notifier).login();
  }

  goToSignupPage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SignupPage())
    );
  }
}
