import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';

class AutocompleteFieldController extends GetxController {
  bool isTextNotEmpty = false;
  List<Map<String, String>> suggestions = [];
  List<Map<String, String>> filteredSuggestions = [];
  bool hasError = false;
  OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();
  final focusNode = FocusNode();
  String? selectedValue;

  void initialize(List<Map<String, String>> initialSuggestions) {
    suggestions = initialSuggestions;
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        validateSelection();
        closeOverlay();
      }
    });
  }

  void updateIsTextNotEmpty(String text) {
    isTextNotEmpty = text.isNotEmpty;
    filterSuggestions(text);
    hasError = false;
    update();
  }

  void filterSuggestions(String query) {
    if (query.isEmpty) {
      filteredSuggestions = suggestions;
    } else {
      filteredSuggestions = suggestions
          .where((suggestion) =>
              suggestion['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  void validateSelection() {
    hasError = selectedValue == null;
    update();
  }

  void clearText(TextEditingController controller) {
    controller.clear();
    updateIsTextNotEmpty('');
    selectedValue = null;
    update();
  }

  void showOverlay(BuildContext context, TextEditingController textController,
      ValueChanged<String?>? onSelected) {
    closeOverlay();
    overlayEntry = createOverlayEntry(context, textController, onSelected);
    Overlay.of(context).insert(overlayEntry!);
  }

  void closeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  OverlayEntry createOverlayEntry(BuildContext context,
      TextEditingController textController, ValueChanged<String?>? onSelected) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            elevation: 4.0,
            child: Container(
              height: getSuggestionBoxHeight(),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = filteredSuggestions[index];
                  return ListTile(
                    title: Text(suggestion['name']!),
                    onTap: () {
                      textController.text = suggestion['name']!;
                      selectedValue = suggestion['value'];
                      onSelected?.call(selectedValue);
                      updateIsTextNotEmpty(suggestion['name']!);
                      closeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getSuggestionBoxHeight() {
    int itemCount = filteredSuggestions.length;
    return itemCount > 4 ? 200 : itemCount * 50;
  }
}

class MyAutocompleteField extends StatelessWidget {
  final String label;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final List<Map<String, String>> suggestions;
  final ValueChanged<String?> onSelected;

  const MyAutocompleteField({
    super.key,
    required this.label,
    required this.textController,
    this.validator,
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AutocompleteFieldController());
    controller.initialize(suggestions);

    return GetBuilder<AutocompleteFieldController>(
      builder: (controller) {
        return CompositedTransformTarget(
          link: controller.layerLink,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: textController,
                focusNode: controller.focusNode,
                decoration: InputDecoration(
                  labelText: label,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  errorText: controller.hasError
                      ? 'Please select a valid option'
                      : null,
                  suffixIcon: controller.isTextNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => controller.clearText(textController),
                        )
                      : null,
                ),
                validator: (value) {
                  return controller.selectedValue == null
                      ? FlutterI18n.translate(
                          context, "error.select_valid_option")
                      : null;
                },
                onChanged: (text) {
                  controller.updateIsTextNotEmpty(text);
                  // Check if input text matches any suggestion
                  final match = controller.suggestions
                      .firstWhereOrNull((s) => s['name'] == text);
                  controller.selectedValue = match?['value'];
                  controller.hasError = controller.selectedValue == null;

                  if (controller.filteredSuggestions.isNotEmpty &&
                      controller.focusNode.hasFocus) {
                    controller.showOverlay(context, textController, onSelected);
                  } else {
                    controller.closeOverlay();
                  }

                  controller.update();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
