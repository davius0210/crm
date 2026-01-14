import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ota_update/ota_update.dart';
import 'main.dart';
import 'style/css.dart' as css;

class UpdateAppPage extends StatefulWidget {
  final String version;
  final String fdPath;
  final String fdFileName;

  const UpdateAppPage({super.key, required this.version, required this.fdPath, required this.fdFileName});

  @override
  State<UpdateAppPage> createState() => LayerUpdateApp();
}

class LayerUpdateApp extends State<UpdateAppPage> {
  String _statusUpdate = '';
  String _downloadPct = '';

  @override
  void initState() {
    super.initState();

    checkUpdate();
  }

  Future<void> checkUpdate() async {
    try {
      OtaEvent? currentEvent;

      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate().execute(
        widget.fdPath,
        destinationFilename: widget.fdFileName,
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        // sha256checksum: 'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
      ).listen(
        (OtaEvent event) {
          setState(() {
            currentEvent = event;
            _statusUpdate = currentEvent!.status.name;
            _downloadPct = currentEvent!.status.index != 0 ? '' : '${currentEvent!.value!} %';
            
        });
        },
      );

      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to make update. Details: $e')));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _downloadPct.isNotEmpty?
              LoadingAnimationWidget.discreteCircle(
                size: 100 * ScaleSize.textScaleFactor(context),
                color: Colors.black, 
                secondRingColor: Colors.red,
                thirdRingColor: Colors.green
              ) :
              const Padding(padding: EdgeInsets.zero),
            const Padding(padding: EdgeInsets.all(15)),
            Text('$_statusUpdate... $_downloadPct', style: css.textNormalBold()),
          ],
        ),
      ),
    );
  }
}
