import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/model/user_list_model.dart';
import 'package:webshop_client/pages/home_page/profile_page/kick_user_item.dart';
import 'package:webshop_client/provider_objects.dart';

import '../../../widgets/dialogs/base_dialog_implementation.dart';

class KickUsersDialog extends ConsumerStatefulWidget {
  const KickUsersDialog({super.key});

  @override
  _KickUsersDialogState createState() => _KickUsersDialogState();
}

class _KickUsersDialogState extends ConsumerState<KickUsersDialog> {
  @override
  Widget build(BuildContext context) {
    final _users = ref.watch(userListModelNotifier);

    return BaseDialogImplementation(
        title: "Kick users",
        onAcceptFunction: () { Navigator.of(context).pop(); },
        body: _users.when(
            data: (UserListModel users) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: users.userList.length,
                itemBuilder: (BuildContext context, int index) {
                  return KickUserItem(users.userList[index]);
                },
              );
            },
            error: (Object error, StackTrace stackTrace) {
              return Text("$error");
            },
            loading: () => Center(child: CircularProgressIndicator(),)
        )
    );
  }
}
