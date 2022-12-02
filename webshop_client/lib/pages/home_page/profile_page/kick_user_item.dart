import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';

import '../../../model/profile_model.dart';
import '../../../model/user_model.dart';
import '../../../widgets/buttons/round_icon_button.dart';
import '../../../widgets/other/rounded_card.dart';
import '../../../widgets/other/snackbars.dart';


class KickUserItem extends ConsumerStatefulWidget {
  final ProfileModel user;
  const KickUserItem(this.user, {super.key});

  @override
  _KickUserItemState createState() => _KickUserItemState();
}

class _KickUserItemState extends ConsumerState<KickUserItem> {
  @override
  Widget build(BuildContext context) {
    return RoundedCard(
        child: ListTile(
          title: Text(widget.user.userName),
          subtitle: Text(widget.user.email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundIconButton(
                icon: Icons.delete,
                onPressed: () {deleteUser(widget.user.userId);},
              ),
            ],
          ),
        )
    );
  }

  deleteUser(String id) {
    setState(() {
      ref.read(userListModelNotifier.notifier).deleteUser(id).catchError((error){
        showErrorSnackbar(context, "Couldn't delete user");
      });
    });
  }
}
