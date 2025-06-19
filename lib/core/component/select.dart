import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

class ShadcnSelect extends StatefulWidget {
  final String? value;
  final List<Map<String, dynamic>> items;
  final String? hintText;
  final String labelText;
  final ValueChanged<Map<String, dynamic>?> onChanged;

  const ShadcnSelect({
    super.key,
    required this.value,
    required this.items,
    this.hintText,
    required this.labelText,
    required this.onChanged,
  });

  @override
  State<ShadcnSelect> createState() => _ShadcnSelectState();
}

class _ShadcnSelectState extends State<ShadcnSelect> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: SizeConst.kBorderRadius,
            color: Theme.of(context).colorScheme.surface,
            child: IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: size.width,
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: SizeConst.kBorderRadius,
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.items.map((item) {
                    return InkWell(
                      onTap: () {
                        widget.onChanged(item);
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: widget.value == item["name"]
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1)
                              : null,
                        ),
                        child: Text(
                          item["name"] ?? "empty name",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showOverlay();
          } else {
            _overlayEntry?.remove();
            _overlayEntry = null;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: SizeConst.kBorderRadius,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.value ?? widget.hintText ?? 'Select',
                  style: TextStyle(
                    color: widget.value != null
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey.shade500,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
