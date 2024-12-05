import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/modules/permission_request/view/permission_request_detail.dart';

import '../model/get_permission_request_model.dart';

class PermissionRequestItem extends StatelessWidget {
  final GetPermissionRequestModel permissionRequestModel;

  const PermissionRequestItem(
      {super.key, required this.permissionRequestModel});
  @override
  Widget build(BuildContext context) {
    final dateArray =
        permissionRequestModel.createdAt.toLocal().toString().split(' ');
    return ListTile(
      onTap: () => Get.to(() =>
          PermissionRequestDetail(permissionRequest: permissionRequestModel)),
      title: Text(
        FlutterI18n.translate(context,
            "permission_request.${permissionRequestModel.permission}_permission"),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
          "${FlutterI18n.translate(context, "permission_request.created_at")}: ${dateArray[0]} ${dateArray[1].substring(0, 8)}"),
      trailing: Chip(label: Text(permissionRequestModel.status)),
    );
  }
}
