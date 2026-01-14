import 'dart:io';
import 'package:flutter/material.dart';
import 'main.dart';
import 'previewphoto_page.dart';
import 'models/salesman.dart' as msf;

class ImagesViewPage extends StatefulWidget {
  final String routeName;
  final msf.Salesman user;
  final List<String> imgList;

  const ImagesViewPage(
      {super.key,
      required this.user,
      required this.routeName,
      required this.imgList});

  @override
  State<ImagesViewPage> createState() => LayerImagesViewPage();
}

class LayerImagesViewPage extends State<ImagesViewPage> {
  bool isLoading = false;
  late PageController _pageController;
  late ScrollController _scrollControl;
  int _activePageIndex = 0;

  @override
  void initState() {
    initLoadPage();
    imageCache.clear();
    imageCache.clearLiveImages();
    super.initState();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });

      _pageController = PageController();
      _scrollControl = ScrollController();

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

  Widget getImage(String imgPath) {
    File imageFile = File(imgPath);
    String noimagePath = 'assets/images/no_image.png';

    if (!imageFile.existsSync()) {
      return InkWell(
        child: Image.asset(noimagePath),
      );
    } else {
      return InkWell(
          onTap: () {
            if (File(imgPath).existsSync()) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviewPictureScreen(
                          imgBytes: File(imgPath).readAsBytesSync())));
            }
          },
          child: Image.file(
            File(imgPath),
            fit: BoxFit.contain,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image,
                  size: 26 * ScaleSize.textScaleFactor(context));
            },
          ));
    }
  }

  createImagePointer(int length, int currentIndex) {
    return List<Widget>.generate(length, (index) {
      File imageFile = File(widget.imgList[index]);
      String noimagePath = 'assets/images/no_image.png';

      if (!imageFile.existsSync()) {
        return Container(
            width: 70 * ScaleSize.textScaleFactor(context),
            height: 100 * ScaleSize.textScaleFactor(context),
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: currentIndex == index ? Colors.blue : Colors.white)),
            child: InkWell(
                onTap: () {
                  setState(() {
                    _activePageIndex = index;
                    _pageController.jumpToPage(_activePageIndex);
                  });
                },
                child: Image.asset(noimagePath)));
      } else {
        return Container(
            width: 70 * ScaleSize.textScaleFactor(context),
            height: 100 * ScaleSize.textScaleFactor(context),
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: currentIndex == index ? Colors.blue : Colors.white)),
            child: InkWell(
                onTap: () {
                  setState(() {
                    _activePageIndex = index;
                    _pageController.jumpToPage(_activePageIndex);
                  });
                },
                child: Image.file(
                  File(widget.imgList[index]),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image,
                        size: 26 * ScaleSize.textScaleFactor(context));
                  },
                )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Image'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                itemCount: widget.imgList.length,
                pageSnapping: true,
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.all(5),
                      child: getImage(widget.imgList[index]));
                },
                onPageChanged: (value) {
                  if (_scrollControl.position.maxScrollExtent > 0) {
                    double newPosition = 0;
                    double totalScrollLength =
                        _scrollControl.position.maxScrollExtent;
                    double imageLength = (totalScrollLength +
                            _scrollControl.position.viewportDimension) /
                        widget.imgList.length;
                    int totalImagesPerHalfPage =
                        (MediaQuery.of(context).size.width / imageLength / 2)
                            .ceil();

                    if ((value + 1) > totalImagesPerHalfPage) {
                      newPosition =
                          ((value + 1) - totalImagesPerHalfPage) * imageLength;

                      if (newPosition > totalScrollLength) {
                        newPosition = totalScrollLength;
                      }
                    } else {
                      newPosition = 0;
                    }

                    _scrollControl.jumpTo(newPosition);
                  }

                  setState(() {
                    _activePageIndex = value;
                  });
                },
              )),
          const Padding(padding: EdgeInsets.all(5)),
          SingleChildScrollView(
              controller: _scrollControl,
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    createImagePointer(widget.imgList.length, _activePageIndex),
              ))
        ]));
  }
}
