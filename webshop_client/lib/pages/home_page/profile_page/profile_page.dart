import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelNotifier);

    if (userModel == null) {
      throw Exception(
          "Profile cannot be null after successful authentication!!");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4,
          child: ListTile(
            leading: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.account_circle_rounded,
                size: 50,
              ),
            ),
            title: Text(userModel.userName),
            subtitle:
            Text("${userModel.role.toString()} | ${userModel.userId}"),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4,
          child: ListTile(
            title: const Text("Edit profile"),
            leading: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.edit),
            ),
            onTap: editeProfile,
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4,
          child: ListTile(
            title: const Text("Delete account"),
            leading: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.delete_forever),
            ),
            onTap: deleteAccount,
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white70,
          elevation: 4,
          child: ListTile(
            title: const Text("Log out"),
            leading: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.logout),
            ),
            onTap: logout,
          ),
        )
      ],
    );
  }

  logout() {
    ref.read(authStateNotifier.notifier).logout();
  }

  deleteAccount() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to permanently delete your account?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: ref.read(authStateNotifier.notifier).deleteAccount,
            child: const Text("Delete Account"),
          ),
        ],
      );
    });
  }

  editeProfile() {}
}
