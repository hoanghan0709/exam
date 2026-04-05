// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:exam/common_widgets/common_scaffold.dart';
import 'package:exam/features/login/entity/google_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The SignInDemo app.
class SignInDemo extends ConsumerWidget {
  const SignInDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleSignInAsync = ref.watch(googleSignInProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: googleSignInAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $e'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(googleSignInProvider),
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            ),
        data:
            (user) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (user != null) ...[
                  ListTile(
                    leading: GoogleUserCircleAvatar(identity: user),
                    title: Text(user.displayName ?? ''),
                    subtitle: Text(user.email),
                  ),
                  const Text('Signed in successfully.'),
                  ElevatedButton(
                    onPressed: () => ref.read(googleSignInProvider.notifier).signOut(),
                    child: const Text('SIGN OUT'),
                  ),
                ] else ...[
                  const Text('You are not currently signed in.'),
                  if (GoogleSignIn.instance.supportsAuthenticate())
                    ElevatedButton(
                      onPressed: () => ref.read(googleSignInProvider.notifier).signIn(),
                      child: const Text('SIGN IN'),
                    ),
                ],
              ],
            ),
      ),
    );
  }
}
