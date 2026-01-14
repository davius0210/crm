import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputComponentType { text, dropdown }

class CustomTextComponent<T> extends StatefulWidget {
  final String? hint;
  final String? labelText; // New property for the label
  final Widget? icon;
  final Function(String)? onChange;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final InputComponentType type; // New property for input type
  final List<DropdownMenuItem<T>>? dropdownItems; // Items for dropdown
  final T? dropdownValue; // Currently selected dropdown value
  final Function(T?)? onDropdownChanged; // Callback for dropdown changes
  final bool? readOnly;
  final String? Function(dynamic)? validator;
  const CustomTextComponent({
    super.key,
    this.controller,
    this.hint,
    this.labelText, // Initialize the new property
    this.icon,
    this.onChange,
    this.keyboardType,
    this.isPassword = false,
    this.type = InputComponentType.text, // Default to text
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.readOnly,
    this.validator, // Inisialisasi validator
  });

  @override
  State<CustomTextComponent<T>> createState() => _CustomTextComponentState<T>();
}

class _CustomTextComponentState<T> extends State<CustomTextComponent<T>> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Widget inputWidget;

    if (widget.type == InputComponentType.dropdown) {
      inputWidget = DropdownButtonFormField<T>(
        value: widget.dropdownValue,
        items: widget.dropdownItems,
        onChanged: widget.onDropdownChanged,
        validator: widget.validator, // Pasang validator di sini
        decoration: _buildInputDecoration(),
      );
    } else {
      inputWidget = TextFormField(
        // Ganti TextField ke TextFormField
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChange,
        readOnly: widget.readOnly ?? false,
        obscureText: widget.isPassword ? _obscureText : false,
        validator: widget.validator, // Pasang validator di sini
        decoration: _buildInputDecoration().copyWith(
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: ColorHelper.border,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null && widget.labelText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelText!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        inputWidget,
      ],
    );
  }

  // Helper agar kodingan dekorasi tidak duplikat
  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: TextStyle(color: ColorHelper.hint),
      prefixIcon: widget.icon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: ColorHelper.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: ColorHelper.border, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        // Border saat validasi salah
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}