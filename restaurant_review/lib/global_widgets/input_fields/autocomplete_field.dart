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

  void onTextChanged(String text, TextEditingController textController,
      ValueChanged<String?>? onSelected, BuildContext context) {
    updateIsTextNotEmpty(text);
    // Check if input text matches any suggestion
    final match = suggestions.firstWhereOrNull((s) => s['name'] == text);
    selectedValue = match?['value'];
    hasError = selectedValue == null;

    if (filteredSuggestions.isNotEmpty && focusNode.hasFocus) {
      showOverlay(context, textController, onSelected);
    } else {
      closeOverlay();
    }

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
  final List<Map<String, String>> suggestions;
  final ValueChanged<String?> onSelected;

  MyAutocompleteField({
    super.key,
    required this.label,
    required this.suggestions,
    required this.onSelected,
  }) : uniqueTag = DateTime.now()
            .microsecondsSinceEpoch
            .toString(); // Generate unique tag

  final String uniqueTag; // Unique tag generated internally

  @override
  Widget build(BuildContext context) {
    // Use Get.put with the internally generated unique tag
    final controller = Get.put(AutocompleteFieldController(), tag: uniqueTag);
    final TextEditingController textController = TextEditingController();
    controller.initialize(suggestions);

    return GetBuilder<AutocompleteFieldController>(
      init: controller,
      tag: uniqueTag, // Attach unique tag to GetBuilder
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
                      ? FlutterI18n.translate(
                          context, "error.select_valid_option")
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
                  controller.onTextChanged(
                      text, textController, onSelected, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
