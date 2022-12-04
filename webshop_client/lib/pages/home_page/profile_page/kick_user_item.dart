import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/provider_objects.dart';
import 'package:webshop_client/widgets/dialogs/loadable_dialog_mixin.dart';

import '../../../model/profile_model.dart';
import '../../../model/user_model.dart';
import '../../../widgets/buttons/round_icon_button.dart';
import '../../../widgets/other/rounded_card.dart';
import '../../../widgets/other/snackbars.dart';


class KickUserItem extends ConsumerStatefulWidget {
  final ProfileModel user;
  const KickUserItem(this.user, {super.key});

  @override
  KickUserItemState createState() => KickUserItemState();
}

class KickUserItemState extends ConsumerState<KickUserItem> with LoadableDialogMixin {
  @override
  Widget build(BuildContext context) {
    final myProfile = ref.read(userModelNotifier)?.userId == widget.user.userId;

    return RoundedCard(
        child: ListTile(
          title: Text(myProfile ? "${widget.user.userName} (👈 me)" : widget.user.userName),
          subtitle: Text(widget.user.email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(!myProfile && widget.user.role != UserRole.admin) RoundIconButton(
                icon: Icons.admin_panel_settings,
                onPressed: () {promoteUser(widget.user.userId);},
              ),
              if(!myProfile) RoundIconButton(
                icon: Icons.delete,
                color: Colors.red,
                onPressed: () {deleteUser(widget.user.userId);},
              ),
            ],
          ),
        )
    );
  }

  deleteUser(String id) {
    showLoading(context);
    ref.read(userListModelNotifier.notifier).deleteUser(id).then((value) {
      hideLoading(context);
      showOkSnackbar(context, "User deleted (mock)");
    }).catchError((error){
      hideLoading(context);
      showErrorSnackbar(context, "Couldn't delete user");
    });
  }

  promoteUser(String id) {
    showLoading(context);
    ref.read(userListModelNotifier.notifier).promoteUser(id).then((value) {
      hideLoading(context);
      showOkSnackbar(context, "User promoted (mock)");
    }).catchError((error){
      hideLoading(context);
      showErrorSnackbar(context, "Couldn't promote user");
    });
  }
}
