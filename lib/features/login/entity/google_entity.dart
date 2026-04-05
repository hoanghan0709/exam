import 'dart:async';
import 'dart:convert';

import 'package:exam/core/service/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? avatar;

  const UserModel({this.id, this.email, this.name, this.avatar});

  UserModel copyWith({String? id, String? email, String? name, String? avatar}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  //tojson
  Map<String, dynamic> toJson() => {"id": id, "email": email, "name": name, "avatar": avatar};

  //from json
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json["id"], email: json["email"], name: json["name"], avatar: json["avatar"]);

  // helper
  String toRawJson() => jsonEncode(toJson());

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(jsonDecode(str));
  //override toString
  @override
  String toString() {
    return 'UserModell{id: $id, email: $email, name: $name, avatar: $avatar}';
  }
}

class UserModelNotifier extends AsyncNotifier<UserModel> {
  //when init app try to read user from storage and set to state
  @override
  Future<UserModel> build() async {
    final service = ref.read(secureStorageServiceProvider);
    final userJson = await service.read(StorageKeys.userLogged);
    if (userJson != null) {
      return UserModel.fromRawJson(userJson);
    }
    return const UserModel();
  }

  Future<void> updateFromGoogle(GoogleSignInAccount account) async {
    state = AsyncValue.data(
      UserModel(
        id: account.id,
        email: account.email,
        name: account.displayName,
        avatar: account.photoUrl,
      ),
    );
    final service = ref.read(secureStorageServiceProvider);

    await service.write(StorageKeys.userLogged, state.value!.toRawJson());
    //read user from storage
    final userJson = await service.read(StorageKeys.userLogged);
    if (userJson != null) {
      print('User loaded from storage: ${UserModel.fromRawJson(userJson)}');
    }
  }

  void clear() {
    state = const AsyncValue.data(UserModel());
    //clear user from storage
    final service = ref.read(secureStorageServiceProvider);
    service.delete(StorageKeys.userLogged);
  }
}

final userModelProvider = AsyncNotifierProvider<UserModelNotifier, UserModel>(
  UserModelNotifier.new,
);

const List<String> _scopes = <String>['https://www.googleapis.com/auth/contacts.readonly'];

const String _clientId = "613237324796-4kjqlph2tsimoms268t2kiq5nonra2gu.apps.googleusercontent.com";
const String _serverClientId =
    "613237324796-4kjqlph2tsimoms268t2kiq5nonra2gu.apps.googleusercontent.com";

class GoogleSignInNotifier extends AsyncNotifier<GoogleSignInAccount?> {
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSub;

  @override
  Future<GoogleSignInAccount?> build() async {
    final signIn = GoogleSignIn.instance;

    await signIn.initialize(clientId: _clientId, serverClientId: _serverClientId);

    _authSub = signIn.authenticationEvents.listen(
      (event) => _handleAuthEvent(event),
      onError: (e) {
        state = AsyncValue.error(e, StackTrace.current);
      },
    );

    // Cleanup khi provider bị dispose
    ref.onDispose(() {
      _authSub?.cancel();
    });

    // Thử silent sign-in
    await signIn.attemptLightweightAuthentication();

    return null; // Sẽ được cập nhật qua stream
  }

  Future<void> _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    state = AsyncValue.data(user);

    // Cập nhật UserModel
    if (user != null) {
      await ref.read(userModelProvider.notifier).updateFromGoogle(user);
    } else {
      ref.read(userModelProvider.notifier).clear();
    }
  }

  Future<void> signIn() async {
    try {
      await GoogleSignIn.instance.authenticate();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.disconnect();
  }
}

final googleSignInProvider = AsyncNotifierProvider<GoogleSignInNotifier, GoogleSignInAccount?>(
  GoogleSignInNotifier.new,
);
