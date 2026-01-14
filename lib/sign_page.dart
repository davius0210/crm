import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'main.dart';

// void main() {
//   runApp(MaterialApp(title: '1', home: SignPage()));
// }

class SignPage extends StatefulWidget {
  final String pageTitle;
  final String token;
  final String routeName;
  final String filePath;
  const SignPage(
      {super.key,
      required this.token,
      required this.routeName,
      required this.pageTitle,
      required this.filePath});

  @override
  State<SignPage> createState() => LayerSign();
}

class LayerSign extends State<SignPage> {
  final SignatureController signController = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    signController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please Sign'),
      ),
      body: Signature(
        controller: signController,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  signController.undo();

                  setState(() {});
                },
                icon: Icon(Icons.undo, size: 24 * ScaleSize.textScaleFactor(context)),
                tooltip: 'Undo',
              ),
              IconButton(
                onPressed: () {
                  signController.redo();

                  setState(() {});
                },
                icon: Icon(Icons.redo, size: 24 * ScaleSize.textScaleFactor(context)),
                tooltip: 'Redo',
              ),
              IconButton(
                onPressed: () async {
                  Uint8List? imgBytes = await signController.toPngBytes();

                  File(widget.filePath).createSync(recursive: true);
                  File(widget.filePath).writeAsBytes(imgBytes!.toList());
                  File(widget.filePath).exists().then((isExist) async {
                    if (isExist) {
                      print(widget.filePath);
                    }
                  });

                  setState(() {
                    final snackBar = SnackBar(
                      content: const Text('Save success!'),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                icon: Icon(Icons.save, size: 24 * ScaleSize.textScaleFactor(context)),
                tooltip: 'Save',
              )
            ],
          )),
    );
  }
}
