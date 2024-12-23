import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_gallery.dart';
import 'package:restaurant_review/modules/permission_request/model/get_permission_request_model.dart';
import 'package:restaurant_review/utils/address_lookup.dart';

class PermissionRequestDetail extends StatelessWidget {
  final GetPermissionRequestModel permissionRequest;
  const PermissionRequestDetail({super.key, required this.permissionRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.white, // Set back icon color to white
        ),
        title: Text(
          FlutterI18n.translate(
              context, "permission_request.permission_request_detail"),
          style: const TextStyle(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getAddressName(permissionRequest.provinceId,
            permissionRequest.districtId, permissionRequest.wardId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildLabelContent(context, "permission_request.id",
                      permissionRequest.id.toString()),
                  const SizedBox(height: 8),
                  _buildLabelContent(context, "permission_request.name",
                      permissionRequest.name ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildLabelContent(context, "permission_request.phone",
                      permissionRequest.phone ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildLabelContent(context, "permission_request.address",
                      '${permissionRequest.street}, ${snapshot.data}'),
                  const SizedBox(height: 8),
                  _buildLabelContent(
                      context,
                      "permission_request.permission",
                      FlutterI18n.translate(context,
                          "permission_request.${permissionRequest.permission}_permission")),
                  const SizedBox(height: 8),
                  _buildLabelContent(context, "permission_request.created_at",
                      permissionRequest.createdAt.toString()),
                  const SizedBox(height: 8),
                  _buildLabelContent(
                      context,
                      "permission_request.status",
                      FlutterI18n.translate(context,
                          "permission_request.${permissionRequest.status}")),
                  const SizedBox(height: 8),
                  ImageGallery(urls: permissionRequest.imageList),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildLabelContent(
      BuildContext context, String labelKey, String content) {
    return RichText(
      text: TextSpan(
        text: '${FlutterI18n.translate(context, labelKey)}: ',
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: AppColors.textBlack),
        children: [
          TextSpan(
            text: content,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
