import 'package:crm_apps/new/component/custom_button_component.dart';
import 'package:flutter/material.dart';

class ToastHelper {
  static OverlayEntry? _currentToast;

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool isConfirm = false,
    String yesLabel = 'Yes',
    String noLabel = 'No',
    Widget? icon,
    ValueChanged<bool>? onConfirm, // true = yes, false = no
  }) {
    // Hapus toast lama jika masih tampil
    _currentToast?.remove();
    _currentToast = null;

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        onTap: onTap,
        isConfirm: isConfirm,
        yesLabel: yesLabel,
        noLabel: noLabel,
        onConfirm: onConfirm,
        icon: icon,
      ),
    );

    overlay.insert(overlayEntry);
    _currentToast = overlayEntry;

    // Jika bukan mode konfirmasi, auto close setelah durasi tertentu
    if (!isConfirm) {
      Future.delayed(duration, () {
        _currentToast?.remove();
        _currentToast = null;
      });
    }
  }

  static void hide() {
    _currentToast?.remove();
    _currentToast = null;
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback? onTap;
  final bool isConfirm;
  final String yesLabel;
  final String noLabel;
  final ValueChanged<bool>? onConfirm;
  final Widget? icon;

  const _ToastWidget({
    required this.message,
    this.onTap,
    this.isConfirm = false,
    this.yesLabel = 'Yes',
    this.noLabel = 'No',
    this.onConfirm,
    this.icon,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}
class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleConfirm(bool isYes) {
    widget.onConfirm?.call(isYes);
    ToastHelper.hide();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil tinggi keyboard
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    // Memberikan padding tambahan jika keyboard muncul
    final double bottomPosition = keyboardHeight > 0 ? keyboardHeight + 20 : 20;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200), // Durasi animasi mengikuti keyboard
      curve: Curves.easeOutCubic,
      left: 16,
      right: 16,
      bottom: bottomPosition, // Posisi dinamis
      child: FadeTransition(
        opacity: _fade,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    widget.icon ??
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (widget.onTap != null)
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Icon(Icons.arrow_forward_ios, size: 14),
                      ),
                  ],
                ),
                if (widget.isConfirm) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _handleConfirm(false),
                        child: Text(
                          widget.noLabel,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      const SizedBox(width: 4),
                      CustomButtonComponent(
                        width: 80,
                        onPressed: () => _handleConfirm(true),
                        title: widget.yesLabel,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}