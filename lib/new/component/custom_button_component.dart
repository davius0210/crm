import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/material.dart';

class CustomButtonComponent extends StatefulWidget {
  final Function()? onPressed;
  final String? title;
  final Widget? icon;
  final BorderRadius? borderRadius;
  final String? loadingText;
  final double? width;
  final Gradient? gradient;
  final Color? color;
  final BoxBorder? border; // New optional border

  const CustomButtonComponent({
    super.key,
    this.icon,
    this.onPressed,
    this.title,
    this.borderRadius,
    this.width,
    this.gradient,
    this.loadingText,
    this.color,
    this.border, // Add to constructor
  });

  @override
  State<CustomButtonComponent> createState() => _CustomButtonComponentState();
}

class _CustomButtonComponentState extends State<CustomButtonComponent> {
  bool isLoading = false;

  Future<void> handleClick() async {
    if (isLoading || widget.onPressed == null) return;
    setState(() => isLoading = true);
    try {
      await widget.onPressed!();
    } catch (e) {
      debugPrint("Error in CustomButtonComponent: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tentukan kondisi disabled
    final bool isDisabled = widget.onPressed == null;

    // 2. Logika Prioritas: 
    // Jika ada parameter color, kita anggap user ingin warna solid, 
    // KECUALI jika parameter gradient juga diisi (prioritas gradient).
    Gradient? effectiveGradient;
    Color? effectiveColor;

    if (isDisabled) {
      effectiveColor = Colors.grey;
      effectiveGradient = null;
    } else {
      if (widget.gradient != null) {
        // Jika ada parameter gradient, gunakan itu (Prioritas Tertinggi)
        effectiveGradient = widget.gradient;
        effectiveColor = null;
      } else if (widget.color != null) {
        // Jika tidak ada gradient tapi ada color, gunakan color solid
        effectiveGradient = null;
        effectiveColor = widget.color;
      } else {
        // Default jika keduanya null (Gunakan Gradient Default)
        effectiveGradient = LinearGradient(
          colors: [ColorHelper.secondary, ColorHelper.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        effectiveColor = null;
      }
    }

    return SizedBox(
      width: widget.width, // Gunakan SizedBox untuk width
      child: Material(
        color: Colors.transparent, // Agar warna Ink yang terlihat
        child: InkWell(
          onTap: isDisabled ? null : handleClick,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          child: Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              border: widget.border,
              color: effectiveColor,
              gradient: effectiveGradient,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? Row(
                      key: const ValueKey('loading'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        if (widget.loadingText != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.loadingText!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    )
                  : Row(
                      key: const ValueKey('content'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          widget.icon!,
                          if (widget.title != null) const SizedBox(width: 8),
                        ],
                        if (widget.title != null)
                          Text(
                            widget.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}