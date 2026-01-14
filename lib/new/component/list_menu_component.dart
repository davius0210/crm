import 'package:crm_apps/new/component/barcode_component.dart';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardTileMenu {
  final Widget title;
  final Widget? subtitle;
  final Widget? suffix;
  final Widget? prefix;
  final Color? backgroundColor;
  final Function()? onPressed;

  CardTileMenu({
    required this.title,
    this.onPressed,
    this.subtitle,
    this.suffix,
    this.prefix,
    this.backgroundColor,
  });
}


// ... bagian CardTileMenu tetap sama ...

class CardListMenuComponent extends StatelessWidget {
  final bool? isEnableChevron;
  final List<CardTileMenu> items;
  final Color? backgroundColor;
  final double? minHeight;
  
  const CardListMenuComponent({
    super.key,
    required this.items,
    this.backgroundColor,
    this.minHeight,
    this.isEnableChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          var val = entry.value;
          final bool isDisabled = val.onPressed == null;

          // Kita buat konten dasarnya
          Widget itemContent = Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: val.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: index == 0 ? const Radius.circular(10) : Radius.zero,
                topRight: index == 0 ? const Radius.circular(10) : Radius.zero,
                bottomLeft: index == items.length - 1 ? const Radius.circular(10) : Radius.zero,
                bottomRight: index == items.length - 1 ? const Radius.circular(10) : Radius.zero,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (val.prefix != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: val.prefix!,
                  ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      val.title,
                      if (val.subtitle != null) val.subtitle!,
                    ],
                  ),
                ),
                if (val.suffix != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: val.suffix!,
                  ),
                if (!isDisabled && isEnableChevron == true)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      CupertinoIcons.right_chevron,
                      size: 20,
                      color: ColorHelper.hint,
                    ),
                  ),
              ],
            ),
          );

          // JIKA DISABLED: Gunakan Opacity + Grayscale lokal
          if (isDisabled) {
            itemContent = Opacity(
              opacity: 0.5, // Membuat efek pudar
              child: ColorFiltered(
                // Menggunakan matrix grayscale manual agar lebih stabil di dalam list
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0,      0,      0,      1, 0,
                ]),
                child: itemContent,
              ),
            );
          }

          return Column(
            children: [
              if (index != 0)
                const BarcodeSeparator(
                  height: 1,
                  barWidth: 3,
                  spacing: 3,
                ),
              // AbsorbPointer memastikan tidak ada event klik yang tembus
              AbsorbPointer(
                absorbing: isDisabled,
                child: InkWell(
                  onTap: val.onPressed,
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0 ? const Radius.circular(10) : Radius.zero,
                    topRight: index == 0 ? const Radius.circular(10) : Radius.zero,
                    bottomLeft: index == items.length - 1 ? const Radius.circular(10) : Radius.zero,
                    bottomRight: index == items.length - 1 ? const Radius.circular(10) : Radius.zero,
                  ),
                  child: itemContent,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}