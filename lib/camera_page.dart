import 'main.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'previewsavephoto_page.dart';

late List<CameraDescription> _listCamera;

class CameraPage extends StatefulWidget {
  final String pageTitle;
  final String token;
  final String routeName;
  final String filePath;
  final bool isLocSaved;
  const CameraPage(
      {super.key,
      required this.token,
      required this.routeName,
      required this.pageTitle,
      required this.filePath,
      required this.isLocSaved});

  @override
  State<CameraPage> createState() => LayerCamera();
}

class LayerCamera extends State<CameraPage> {
  bool isLoading = false;
  CameraController? camcontroller;
  XFile? image;
  double _zoomVal = 1;
  double _zoomMax = 1;
  bool showZoom = false;
  bool isAutoFocus = true;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  @override
  void initState() {
    initLoadPage();

    super.initState();
  }

  void initLoadPage() async {
    try {
      loadCamera();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  Future<void> loadCamera() async {
    _listCamera = await availableCameras();
    if (_listCamera != null) {
      _zoomVal = 1;
      camcontroller = CameraController(_listCamera[0], ResolutionPreset.medium); //medium spy dapat lebar dan tinggi lebih jauh tetapi kualitas berkurang (masih terlihat)

      await camcontroller!.initialize().then((_) {
        if (!mounted) {
          return;
        }

        camcontroller!.setZoomLevel(_zoomVal);

        setState(() {}); //Update UI
      }).onError((error, stackTrace) {
        print('error: $error');
      });

      _zoomMax = await camcontroller!.getMaxZoomLevel();
    } else {
      print("No any camera found");
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    if (camcontroller != null) camcontroller!.dispose();

    super.dispose();
  }

  void takePhoto() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (camcontroller!.value.isInitialized) {
        //check if controller is initialized
        image = await camcontroller!.takePicture(); //capture image

        if (!mounted) return;

        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewAndSavePictureScreen(
                    image: image!,
                    token: widget.token,
                    filePath: widget.filePath,
                    routeName: widget.routeName,
                    isLocSaved: widget.isLocSaved)));
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  void handleScaleStart(ScaleStartDetails details) {
    _baseScale = _zoomVal;
  }

  Future<void> handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (camcontroller == null || _pointers != 2) {
      return;
    }

    setState(() {
      _zoomVal = (_baseScale * details.scale).clamp(1, _zoomMax);
    });

    await camcontroller!.setZoomLevel(_zoomVal);
  }

  void focusChange(TapDownDetails details, BoxConstraints constraints) async {
    try {
      if (camcontroller == null) {
        return;
      }

      final Offset offset = Offset(
        details.localPosition.dx / constraints.maxWidth,
        details.localPosition.dy / constraints.maxHeight,
      );

      camcontroller!.setFocusMode(FocusMode.locked);
      camcontroller!.setExposureMode(ExposureMode.locked);
      camcontroller!.setExposurePoint(offset);
      camcontroller!.setFocusPoint(offset);

      setState(() {
        isAutoFocus = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: Stack(children: [
        Center(
          child: SizedBox(
            height: 4/3 * MediaQuery.of(context).size.width, //MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: camcontroller == null
              ? const Center(child: Text("Loading Camera..."))
              : !camcontroller!.value.isInitialized
                ? loadingProgress(ScaleSize.textScaleFactor(context)) : 
                  Listener(
                    onPointerDown: (_) => _pointers++,
                    onPointerUp: (_) => _pointers--,
                    onPointerCancel: (event) => _pointers = 0,
                    child: CameraPreview(
                      camcontroller!,
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onScaleStart: handleScaleStart,
                            onScaleUpdate: handleScaleUpdate,
                            onDoubleTapDown: (TapDownDetails details) => focusChange(details, constraints),
                          );
                        }
                      ),
                    )
                  )
          )
        ),
        (showZoom?
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Slider(
                  min: 1,
                  max: _zoomMax,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  value: _zoomVal, 
                  onChanged: (value) {
                    setState(() {
                      _zoomVal = value;
                    });

                    camcontroller!.setZoomLevel(_zoomVal);
                  },
                ))))
            : const Padding(padding: EdgeInsets.zero)),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: isLoading? loadingProgress(ScaleSize.textScaleFactor(context)) :
              Row(
                children: [
                  FloatingActionButton.small(
                    heroTag: null,
                    onPressed: () {
                      setState(() {
                        showZoom = !showZoom;
                      });
                    },
                    tooltip: 'Zoom',
                    elevation: 6,
                    backgroundColor: Colors.grey[800],
                    // shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 1.5)),
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white, width: 1)
                    ),
                    child: Text('${ _zoomVal.toStringAsFixed(1)}x', style: const TextStyle(fontSize: 11))
                  ),
                  isAutoFocus? const Padding(padding: EdgeInsets.zero) :
                    FloatingActionButton.small(
                      heroTag: Null,
                      tooltip: 'Focus',
                      elevation: 6,
                      backgroundColor: Colors.grey[800],
                      shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 1.5)),
                      child: const Icon(Icons.filter_center_focus),
                      onPressed: () { //Balikkan camera ke auto focus
                        try {
                          if (camcontroller != null) {
                            const Offset offset = Offset(0.5, 0.5);
        
                            camcontroller!.setFocusPoint(offset); 
                            camcontroller!.setExposurePoint(offset);     
                            camcontroller!.setFocusMode(FocusMode.auto);    
                            camcontroller!.setExposureMode(ExposureMode.auto);
                          }

                          setState(() {
                            isAutoFocus = true;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                                SnackBar(content: Text('error: $e')));
                        }
                      }
                    )
                ],
              ))
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: isLoading
                    ? loadingProgress(ScaleSize.textScaleFactor(context))
                    : FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          takePhoto();
                        },
                        tooltip: 'Camera',
                        elevation: 6,
                        child: Icon(Icons.camera_alt,
                            size: 24 * ScaleSize.textScaleFactor(context))))),
      ]),
    );
  }
}
