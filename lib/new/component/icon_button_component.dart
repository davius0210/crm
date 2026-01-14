import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/material.dart';

class IconButtonComponent extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final Widget? child;
  final Color? color;
  const IconButtonComponent({super.key, this.child, this.color, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Ink(
          height: 95,
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5,),
              if(child!=null) Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: CircleAvatar(child: child,backgroundColor: color ?? ColorHelper.primary,),
              ),
              Text('$label', textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
}